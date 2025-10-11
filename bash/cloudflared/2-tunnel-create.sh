#color
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  RESET='\033[0m'

rm -rf ~/.cloudflared/*.json
read -r -p "Masukkan nama tunnel:" TUNNEL
if ./cloudflared tunnel create "$TUNNEL"; then
echo -e "${GREEN}(INFO) tunnel $TUNNEL berhasil di buat ${RESET}"
else
echo -e "${RED}(ERR) tunnel $TUNNEL gagal di buat ${RESET}"
exit 1
fi
