{
  # Disable iptables.
  networking.firewall.enable = false;

  # Enable Network Manager
  networking.networkmanager = {
    enable = true;
  };

  # Enable nftables and add rules.
  networking.nftables = {
    enable = true;
    rulesetFile = ./files/nftables;
  };
}
