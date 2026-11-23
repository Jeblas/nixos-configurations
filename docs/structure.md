# Repository structure

This document explains how the pieces of this flake fit together: what each
directory owns, how a host is composed, and where to make common changes.

Companion documents: [ubuntu-profile.md](ubuntu-profile.md) (using the flake's
package outputs on Ubuntu/macOS), `applications.md` at the repo root (an
inventory of installed applications).

---

## The mental model

Every `nixosConfiguration` answers three orthogonal questions, all expressed
in `flake.nix`:

1. **Which software image?** — an entry from `environments/`
   (`base`, `desktop`, `hyprland-desktop`, `plasma-desktop`)
2. **Which hardware?** — a machine from `machines/` plus shared `devices/`
3. **Which users are active?** — `hostUsers`, selected from the registry in
   `users/default.nix`

Everything else hangs off those three.

```nix
tigris = nixpkgs.lib.nixosSystem {
  modules = commonModules ++ [
    ./machines/tigris                      # hardware
    ./environments/hyprland-desktop.nix    # software image
    ./users/base.nix                       # account policy + hostUsers option

    { hostUsers = [ "jeblas" ]; }          # active users (first = primary)

    ./settings/services/printing.nix       # optional extras
    ...
  ];
};
```

---

## Directory map

| Path | Owns | Notes |
|------|------|-------|
| `flake.nix` | Composition: hosts, `specialArgs`, active users; plus the non-NixOS outputs (Ubuntu/darwin profiles, dev shells, formatter) | The only file that names images, machines and users together |
| `environments/` | **Software images**, layered | `hyprland-desktop` → `desktop` → `base`; `plasma-desktop` → `desktop` |
| `machines/` | **Per-machine composite hardware** | `machines/tigris/default.nix` is the machine's composition root |
| `devices/` | **Device layer** shared between machines | `cpu/` (generic `intel.nix` + machine model `i9-7900x.nix`), `gpu/nvidia.nix`, `bluetooth.nix` |
| `settings/` | **NixOS config modules** (`config` values, not declarations) | Root = always-on machine settings; `settings/services/` = optional daemons |
| `settings/programs/` | **Home Manager content** — pure HM attr sets (`programs.*`, `home.*`) | Formerly `home/`; imported *into* `home-manager.users.<name>` |
| `home-manager/` | **NixOS-level HM wiring per layer**: `home-manager.users.*`, `useGlobalPkgs`, per-layer `home.packages` | Mirrors the `environments/` layering |
| `users/` | **Who exists** | `default.nix` = registry (data), `base.nix` = `hostUsers` option + account policy |
| `packages/` | **Package lists** reused across HM layers *and* the flake's profile/dev-shell outputs | `common` → `linux` → `desktop` → `hyprland`; also `darwin`, `server` |
| `docs/` | This documentation | |
| `build.sh` | `nixos-rebuild switch --flake .#tigris` | |

---

## How the layers compose (tigris)

### System side

```
flake.nix
└── environments/hyprland-desktop.nix      # compositor, greetd, session tools
    ├── environments/desktop.nix           # X11, apps, nix-ld, sound
    │   ├── environments/base.nix          # fonts, base packages, prompt
    │   │   ├── settings/{networking,localization,nix,nixpkgs}.nix
    │   │   ├── settings/services/{ssh,avahi,podman}.nix
    │   │   └── home-manager/base.nix      # ← HM wiring starts here
    │   ├── settings/sound.nix
    │   └── home-manager/desktop.nix
    ├── home-manager/hyprland-desktop.nix
    └── (flake) settings/services/{printing,virtualization}.nix
```

### Hardware side (tigris)

```
machines/tigris/default.nix                # composition root
├── nixos-hardware: common-pc, common-pc-ssd        # via specialArgs input
├── hardware-configuration.nix             # not-detected + hostPlatform
├── networking.nix                         # interfaces, DHCP, wireless
├── boot.nix / filesystems.nix             # kernel, bootloader, partitions
├── devices/bluetooth.nix
├── devices/gpu/nvidia.nix                 # + nixos-hardware common-gpu-nvidia-nonprime
└── devices/cpu/i9-7900x.nix               # machine model
    └── devices/cpu/intel.nix              # generic + nixos-hardware common-cpu-intel-cpu-only
```

Rule of thumb: **`machines/` knows which parts; `devices/` knows how they
work; `nixos-hardware` modules travel with the device file they describe.**

### User side

```
users/default.nix          registry: users = [ { userName, email,
                             description, uid, hashedPassword } ]
users/base.nix             options.hostUsers : listOf (enum registry names)
                             ├── users.users = genAttrs hostUsers → accounts
                             └── (read everywhere else, see below)
flake.nix                  { hostUsers = [ "jeblas" ]; }   # per host
```

`config.hostUsers` is the single source of "who is on this machine":

| consumer | uses it for |
|---|---|
| `users/base.nix` | creating the accounts |
| `home-manager/*.nix` | `home-manager.users = genAttrs hostUsers …` — every selected user gets the HM profile |
| `environments/hyprland-desktop.nix` | `head` = the greetd session user |
| `settings/services/virtualization.nix` | `head` = who gets the `libvirtd` group |
| `settings/nix.nix` | `trusted-users` |

Inside a Home Manager module, `config.home.username` identifies *which* of
those users the profile belongs to — `settings/programs/base.nix` uses it to
look the entry up in the registry (e.g. for `user.name`/`user.email`).

---

## Module-system rules this repo follows

1. **A NixOS module cannot set top-level `home.*` options.** All Home Manager
   configuration lives *nested* under `home-manager.users.<name>` (the
   `home-manager/*.nix` files do this; `settings/programs/*.nix` are then
   plain HM modules imported into that namespace).
2. **Lists merge, they don't override.** `home.packages` and
   `environment.systemPackages` definitions concatenate across layers — that's
   why `home-manager/base.nix`, `home-manager/desktop.nix` and
   `home-manager/hyprland-desktop.nix` can each contribute a package list.
3. **`specialArgs` carries flake inputs, not config**: `nixpkgsSrc`,
   `hostName`, and `nixos-hardware` (required by `devices/cpu/intel.nix` and
   `devices/gpu/nvidia.nix`). Anything host-specific and declarative belongs
   in an option (like `hostUsers`), not in `specialArgs`.
4. **Where packages go**:
   - system-wide (all users, session-critical): `environment.systemPackages`
     in `environments/<image>.nix`
   - per user (declarative layers): `home.packages`, fed by `packages/*.nix`
     through `home-manager/*.nix`
   - the plain `neovim` is dropped from the HM lists (`lib.remove pkgs.neovim`)
     because `programs.neovim`'s wrapped build has the same name and would
     collide in the profile `buildEnv`.

---

## Common tasks

**Add a package to my user profile**
→ `packages/common.nix` (everything), or `packages/desktop.nix` /
`packages/hyprland.nix` if it belongs to that layer.

**Add a system-wide package (all users / before login)**
→ `environment.systemPackages` in the relevant `environments/<image>.nix`.

**Add declarative config for a program**
→ a `settings/programs/<name>.nix` module, imported from the matching
`home-manager/<layer>.nix` (`home-manager.users.<name>.imports`).

**Add an optional service to one host**
→ `settings/services/<name>.nix`, add it to that host's module list in
`flake.nix` (like `printing.nix`).

**Add a user**
→ 1. entry in `users/default.nix` (`users = [ … ]`; pick a distinct `uid`),
   2. add the name to that host's `hostUsers` in `flake.nix`.
   Accounts and the full HM profile follow automatically.

**Add a machine**
→ `machines/<name>/default.nix` (compose hardware: `hardware-configuration`,
machine-specific `boot`/`filesystems`, relevant `devices/*`) plus a new
`nixosConfigurations.<name>` block in `flake.nix` mirroring tigris:
image + machine + `./users/base.nix` + `hostUsers`.

---

## Conventions and gotchas

- **New `.nix` files must be tracked**: Nix flakes only see *tracked* files.
  After creating one, run `git add -N <file>` or every eval fails with
  "path is not tracked by git".
- **Verify without switching**:
  ```sh
  nix eval --raw .#nixosConfigurations.tigris.config.system.build.toplevel.drvPath
  nix build --no-link .#nixosConfigurations.tigris.config.system.build.toplevel
  ```
  A pure refactor should produce the *same* drv path as before your change;
  a different drv means the closure actually changed.
- **`settings/` vs `environments/`**: `settings/` holds reusable config
  fragments; `environments/` picks and layers them into an image.
- **Keep comments honest**: when moving code between layers, the header
  comments in `home-manager/*.nix` and `devices/*` describe what travels
  where — update them with the move.
- Home Manager runs as a NixOS module (`home-manager-jeblas.service`), so
  `nixos-rebuild switch` is the only activation step — there is no separate
  `home-manager switch`.