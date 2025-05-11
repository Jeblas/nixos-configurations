{config, pkgs, ...} : {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.configFile = pkgs.writeText "default.pa" ''
    load-module module-combine-sink
    # Bluetooth
    load-module module-switch-on-connect
    load-module module-bluetooth-policy
    load-module module-bluetooth-discover
    ## module fails to load with
    ##   module-bluez5-device.c: Failed to get device path from module arguments
    ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    # load-module module-bluez5-device
    # load-module module-bluez5-discover
    # Default to DAC
    set-default-sink alsa_output.usb-aune_S6_USB_DAC-00.analog-stereo
    set-default-source alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input
  '';
}
