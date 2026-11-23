# The registry of every user this configuration knows about.
#
# Each nixosConfiguration selects from here via its `hostUsers` option
# (see users/base.nix): selected users become NixOS accounts and get the
# Home Manager profile, and the first entry is the host's primary user.
{
  users = [
    {
      userName = "jeblas";
      # Optional: fullName = "…";  when absent, git's user.name falls back
      # to userName (see settings/programs/base.nix).
      # TODO: set once an address is configured; empty omits user.email
      # from the generated gitconfig (an empty value makes git refuse commits).
      email = "";
      description = "";
      uid = 1000;
      hashedPassword = "$y$j9T$JDnjfZlgeJlPTsuVD91rS0$vEMav2JL1VYdR6qDkOyFwO0RTAZZH7g/nnDXm9FuauC"; # use mkPassword to generate
    }
  ];
}