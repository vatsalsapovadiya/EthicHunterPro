#!/bin/bash
# EthicHunter Pro - Advanced Bug Hunting Toolkit
# GitHub: https://github.com/YourUsername/EthicHunterPro

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║  ███████╗████████╗██╗  ██╗██╗ ██████╗███████╗██╗  ██╗██████╗  ║
║  ██╔════╝╚══██╔══╝██║  ██║██║██╔════╝██╔════╝██║  ██║██╔══██╗ ║
║  █████╗     ██║   ███████║██║██║     █████╗  ███████║██████╔╝ ║
║  ██╔══╝     ██║   ██╔══██║██║██║     ██╔══╝  ██╔══██║██╔═══╝  ║
║  ███████╗   ██║   ██║  ██║██║╚██████╗███████╗██║  ██║██║      ║
║  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝      ║
╠═══════════════════════════════════════════════════════════════╣
║                   E T H I C H U N T E R   P R O               ║
║                     Advanced Edition v2.0                      ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check domain
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <domain> [options]${NC}"
    echo -e "${YELLOW}Options:"
    echo -e "  --recon       : Run reconnaissance only"
    echo -e "  --osint       : Run OSINT gathering"
    echo -e "  --vuln        : Run vulnerability scanning"
    echo -e "  --manual      : Enable manual testing mode"
    echo -e "  --anon        : Enable Tor/VPN"
    echo -e "  --rate-limit  : Slow down scans"
    echo -e "  --honeypot    : Check for honeypots"
    echo -e "Example: $0 example.com --recon --osint --anon${NC}"
    exit 1
fi

# Initialize
DOMAIN=$1
OUTPUT_DIR="ethicHunter_$DOMAIN"
TOOLS_DIR="$OUTPUT_DIR/tools_output"
REPORT="$OUTPUT_DIR/report_$(date +%Y%m%d).md"
mkdir -p "$TOOLS_DIR"

# Load modules
source modules/recon.sh
source modules/osint.sh
source modules/vuln_scan.sh
source modules/manual_testing.sh
source modules/counter_intel.sh
source modules/reporting.sh

# Parse options
while [[ $# -gt 0 ]]; do
    case "$2" in
        --recon)
            run_recon "$DOMAIN" "$OUTPUT_DIR" "$TOOLS_DIR"
            ;;
        --osint)
            run_osint "$DOMAIN" "$OUTPUT_DIR" "$TOOLS_DIR"
            ;;
        --vuln)
            run_vuln_scan "$DOMAIN" "$OUTPUT_DIR" "$TOOLS_DIR"
            ;;
        --manual)
            run_manual_testing "$DOMAIN" "$OUTPUT_DIR" "$TOOLS_DIR"
            ;;
        --anon)
            echo -e "${YELLOW}[*] Enabling Tor/VPN...${NC}"
            sudo systemctl start tor
            proxychains ./ethicHunterPro.sh "$DOMAIN" "${@:3}"
            exit
            ;;
        --rate-limit)
            echo -e "${YELLOW}[*] Slowing down scans...${NC}"
            export FFUF_DELAY=1
            ;;
        --honeypot)
            check_honeypot "$DOMAIN" "$TOOLS_DIR"
            ;;
        *)
            echo -e "${RED}[!] Unknown option: $2${NC}"
            ;;
    esac
    shift
done

# Generate report
generate_report "$DOMAIN" "$OUTPUT_DIR" "$REPORT"

# Final message
echo -e "\n${GREEN}[+] Scan completed! Results saved to $OUTPUT_DIR/${NC}"
echo -e "${BLUE}[+] Report: $REPORT${NC}"
