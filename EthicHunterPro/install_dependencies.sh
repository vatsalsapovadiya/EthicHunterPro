#!/bin/bash
echo -e "${GREEN}Installing EthicHunter Pro dependencies...${NC}"

# System packages
sudo apt update
sudo apt install -y git nmap jq python3-pip tor proxychains

# Go tools
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest

# Python tools
pip install sublist3r theHarvester

# Snap tools
sudo snap install amass

# Manual testing tools
sudo apt install -y gobuster nikto burpsuite

# Add to PATH
echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
source ~/.bashrc

echo -e "\n${GREEN}[+] All dependencies installed!${NC}"
echo -e "${BLUE}[+] Run: ./ethicHunterPro.sh example.com --recon --osint${NC}"
