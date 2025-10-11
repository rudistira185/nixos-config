
#color
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  RESET='\033[0m'

if [ -f /home/carlos/nixos-config/bash/cloudflared/cloudflared ]; then
echo -e "${GREEN}(INFO) file exist ${RESET}"
echo -e "${RED} exiting ${RESET}"
exit 1
else
echo -e "${GREEN}(INFO)downloading cloudflared ${RESET}"
     if wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64; then
     echo -e "${GREEN}(INFO) Download success ${RESET}"
     chmod +x cloudflared
     else
     echo -e "${RED}(ERR)download failed ${RESET}"
     exit 1
    fi
fi
