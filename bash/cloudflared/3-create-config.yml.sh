#!/usr/bin/env bash
rm -rf ~/.cloudflared/config.yml
# hanya minta Tunnel ID dan Hostname, lalu tulis file dengan echo

read -r -p "Masukkan Tunnel ID: " TUNNEL_ID
read -r -p "Hostname (default: ssh.rudistira185.shop): " HOSTNAME
HOSTNAME="${HOSTNAME:-ssh.rudistira185.shop}"

# pastikan direktori ada (opsional tapi aman)
mkdir -p ~/.cloudflared

# tulis file dengan echo
echo "tunnel: $TUNNEL_ID # Ganti dengan ID Tunnel Anda" > ~/.cloudflared/config.yml
echo "credentials-file: ~/.cloudflared/*.json" >> ~/.cloudflared/config.yml
echo "ingress:" >> ~/.cloudflared/config.yml
echo "  - hostname: $HOSTNAME" >> ~/.cloudflared/config.yml
echo "    service: ssh://localhost:22" >> ~/.cloudflared/config.yml
echo "  - service: http_status:404 # Fallback: blokir semua permintaan lain" >> ~/.cloudflared/config.yml

echo "Selesai. File ditulis ke ~/.cloudflared/config.yml"

