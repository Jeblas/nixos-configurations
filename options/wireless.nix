{config, ...} : {
  networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant.
    # wpa_cli
    # scan
    # scan_results
    # add_network
    # set_network 0 ssid "laganini"
    # set_network 0 psk "secret"
    # or set_network 0 key_mgmt NONE
    # enable_network 0
    userControlled.enable = true;
    networks = {
    };
  };
}
