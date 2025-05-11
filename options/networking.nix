{ hostName, ... }:
{
  networking = {
    inherit hostName;
    # networkmanager.enable = true;
    enableIPv6 = true;
    nameservers = ["1.1.1.3"];
    
     # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;
  };
}
