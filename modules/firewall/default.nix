{
  # Disable iptables.
  networking.firewall.enable = false;

  # Enable Network Manager
  networking.networkmanager.enable = true;

  # Enable nftables and add rules.
  networking.nftables = {
    enable = true;
    tables = {
      filter = {
        family = "inet";
        content = ''
          counter drop_loop_v4 {}
          counter drop_loop_v6 {}

          # https://pablotron.org/articles/nftables-examples/
          # chromecast IPs (chatty in the ephemeral udp port range)
          # src: https://blog.g3rt.nl/allow-google-chromecast-host-firewall-iptables.html
          define CHROMECASTS = {
            192.168.1.18,
          }

          # Check out https://wiki.nftables.org/ for better documentation.
          # Table for both IPv4 and IPv6.
          # Block all incoming connections traffic except SSH and "ping".
          chain input {
            type filter hook input priority 0;

            # accept any localhost traffic
            iifname lo accept

            # accept traffic originated from us
            ct state {established, related} accept

            # accept all loopback/virbr* traffic
            # NOTE: "iifname" is slower than "iif", but it allows name globbing
            iif lo accept comment "accept iif lo"
            iifname "virbr*" accept comment "accept iif virbr*"

            # drop loopback traffic on non-loopback interfaces
            iif != lo ip daddr 127.0.0.1/8 counter name drop_loop_v4 drop \
              comment "drop invalid loopback traffic"
            iif != lo ip6 daddr ::1/128 counter name drop_loop_v6 drop \
              comment "drop invalid loopback traffic"

            # ICMP
            # routers may also want: mld-listener-query, nd-router-solicit
            ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
            ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

            # allow "ping"
            ip6 nexthdr icmpv6 icmpv6 type echo-request accept
            ip protocol icmp icmp type echo-request accept

            # accept chromecast traffic
            ip saddr $CHROMECASTS udp dport 32768-65535 \
              accept comment "accept chromecast"

            # accept mdns traffic
            udp dport 5353 counter accept comment "accept mdns"

            # count and drop any other traffic
            counter drop
          }

          # Allow all outgoing connections.
          chain output {
            type filter hook output priority 0;
            accept
          }

          chain forward {
            type filter hook forward priority 0;
            accept
          }
        '';
      };
    };
  };
}
