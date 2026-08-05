#!/usr/bin/env bash
set -euo pipefail

REGION="${PIA_REGION:-nl_amsterdam}"
WG_KEY_DIR="${WG_KEY_DIR:-/etc/wireguard}"
NIX_DIR="$(dirname "$(realpath "$0")")"
WG_NIX="$NIX_DIR/wireguard.nix"
CONFIG_NIX="$NIX_DIR/configuration.nix"

# Credentials
if [[ -z "${PIA_USER:-}" ]]; then
  read -rp "PIA username: " PIA_USER
fi
if [[ -z "${PIA_PASS:-}" ]]; then
  read -rsp "PIA password: " PIA_PASS
  echo
fi

# Get auth token
echo "Getting PIA token..."
TOKEN=$(curl -s -u "$PIA_USER:$PIA_PASS" "https://www.privateinternetaccess.com/gtoken/generateToken" | jq -r '.token')
if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
  echo "Failed to get token. Check your credentials." >&2
  exit 1
fi

# Get server info for region
echo "Getting server info for region: $REGION..."
SERVER=$(curl -s "https://serverlist.piaservers.net/vpninfo/servers/v6" \
  | head -1 \
  | jq -r ".regions[] | select(.id==\"$REGION\") | .servers.wg[0]")

SERVER_IP=$(echo "$SERVER" | jq -r '.ip')
SERVER_CN=$(echo "$SERVER" | jq -r '.cn')

if [[ -z "$SERVER_IP" || "$SERVER_IP" == "null" ]]; then
  echo "Could not find server for region '$REGION'." >&2
  exit 1
fi

echo "Server: $SERVER_CN ($SERVER_IP)"

# Generate WireGuard keypair if needed
PRIVKEY_FILE="$WG_KEY_DIR/privatekey"
PUBKEY_FILE="$WG_KEY_DIR/publickey"

if [[ ! -f "$PRIVKEY_FILE" ]]; then
  echo "Generating WireGuard keypair in $WG_KEY_DIR..."
  mkdir -p "$WG_KEY_DIR"
  wg genkey | tee "$PRIVKEY_FILE" | wg pubkey > "$PUBKEY_FILE"
  chmod 600 "$PRIVKEY_FILE"
fi

PUBKEY=$(cat "$PUBKEY_FILE")
echo "WireGuard public key: $PUBKEY"

# Register public key with PIA server (token and pubkey must be URL-encoded)
echo "Registering key with PIA server..."
TOKEN_ENC=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$TOKEN")
PUBKEY_ENC=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$PUBKEY")
RESPONSE=$(curl -sk "https://$SERVER_IP:1337/addKey?pt=$TOKEN_ENC&pubkey=$PUBKEY_ENC")

STATUS=$(echo "$RESPONSE" | jq -r '.status')
if [[ "$STATUS" != "OK" ]]; then
  echo "Key registration failed: $RESPONSE" >&2
  exit 1
fi

SERVER_PUBKEY=$(echo "$RESPONSE" | jq -r '.server_key')
PEER_IP=$(echo "$RESPONSE" | jq -r '.peer_ip')
DNS=$(echo "$RESPONSE" | jq -r '.dns_servers[0]')

# Write wireguard.nix
cat > "$WG_NIX" <<NIXCONF
{ ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "$PEER_IP/32" ];
    dns = [ "$DNS" ];
    privateKeyFile = "$PRIVKEY_FILE";
    peers = [{
      publicKey = "$SERVER_PUBKEY";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      endpoint = "$SERVER_IP:1337";
      persistentKeepalive = 25;
    }];
  };
}
NIXCONF
echo "Written $WG_NIX"

# Add import to configuration.nix if not already there
if ! grep -q "wireguard.nix" "$CONFIG_NIX"; then
  sed -i 's|./hardware-configuration.nix|./hardware-configuration.nix\n      ./wireguard.nix|' "$CONFIG_NIX"
  echo "Added wireguard.nix to $CONFIG_NIX imports"
fi

HOME=/home/frbl nixos-rebuild switch --flake "$NIX_DIR#frbl-x1-nixos"
echo ""
echo "Done! Run: sudo wg-quick up wg0"
