{config, pkgs, ...} : {
  services.openssh = {
    # Enable the OpenSSH daemon.
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  systemd.services.ssh-inhibit-sleep = {
    enable = true;
    description = "prevent sleep when a user is connected over ssh";
    unitConfig = {
      Before = "sleep.target";
    };
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '! who | grep \"pts\"'";
      #ExecStart = "${pkgs.bash}/bin/bash -c '! who | grep -qv \"\\(:0\\)\"'";
      Type = "oneshot";
    };
    requiredBy = ["sleep.target"];
  };
}
