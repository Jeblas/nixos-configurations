{ config, pkgs, lib, ... }:
{
  # Applications from environments/desktop.nix that support declarative config.
  # Packages are still installed system-wide; these modules only manage config.

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        dynamic_padding = true;
        opacity = 0.95;
      };
      font = {
        normal.family = "Hack Nerd Font";
        size = 11;
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
      };
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      "save-position-on-quit" = true;
    };
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      # Merge HM settings into the existing file instead of replacing it.
      mutableUserSettings = true;
      userSettings = {
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "nix.enableLanguageServer" = true;
      };
    };
  };

  # Keep OpenCode's own settings mutable; HM only supplies the declarative layer.
  programs.opencode = {
    enable = true;
    mutableSettings = true;
  };
}
