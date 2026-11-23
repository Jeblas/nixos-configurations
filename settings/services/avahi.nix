{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish.enable = true;
    publish.addresses = true;
    openFirewall = true;  # for a WiFi printer
  };
}
