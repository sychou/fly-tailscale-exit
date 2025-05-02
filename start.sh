#!/usr/bin/env sh

set -e

echo "Starting Tailscale exit node setup..."

# Enable IP forwarding for IPv4 and IPv6
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Set up NAT for outbound traffic
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Start tailscaled in the background
tailscaled --state=mem: --port=41641 &

# Wait for tailscaled to become ready
sleep 2

# Bring up the Tailscale interface
tailscale up \
  --authkey="${TAILSCALE_AUTH_KEY}" \
  --hostname="fly-${FLY_REGION}" \
  --advertise-exit-node

echo "✅ Tailscale is up and running as an exit node."

# Keep container alive
sleep infinity