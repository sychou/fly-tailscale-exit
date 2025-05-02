FROM alpine:latest

# Install only what's necessary
RUN apk update && apk add --no-cache \
    tailscale \
    iptables \
    ip6tables \
    ca-certificates

# Create directories required by Tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Copy local startup script into container
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Run on container startup
USER root
CMD ["/app/start.sh"]