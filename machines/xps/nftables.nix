{
  # Disable iptables.
  networking.firewall.enable = false;

  # Enable nftables and add rules.
  networking.nftables = {
    enable = true;
    rulesetFile = ./files/nftables;
  };
}
