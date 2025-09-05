#!/bin/bash

check_honeypot() {
    DOMAIN=$1
    TOOLS_DIR=$2
    echo -e "${GREEN}[+] Checking for honeypots...${NC}"
    curl -I "http://$DOMAIN/.git/config" > "$TOOLS_DIR/honeypot_check.txt"
}

monitor_connections() {
    echo -e "${GREEN}[+] Monitoring connections...${NC}"
    tcpdump -i eth0 -n "tcp[tcpflags] == tcp-syn" | awk '{print $3}' >> "$TOOLS_DIR/suspicious_ips.txt"
}
