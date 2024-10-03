#!/bin/bash

# Color Variables for Better User Experience
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# Banner Function
function print_banner() {
    echo -e "${CYAN}"
    echo "############################################################"
    echo "#                                                          #"
    echo "#              Bug Bounty Tool Installer Script            #"
    echo "#                                                          #"
    echo "############################################################"
    echo -e "${RESET}"
}

# List of Tools with GitHub URLs or installation commands
declare -A TOOLS
TOOLS=(
    ["Amass"]="https://github.com/OWASP/Amass"
    ["Anew"]="https://github.com/tomnomnom/anew"
    ["Anti-burl"]="https://github.com/tomnomnom/hacks/tree/master/anti-burl"
    ["Assetfinder"]="https://github.com/tomnomnom/assetfinder"
    ["Airixss"]="https://github.com/ferreiraklet/Airixss"
    ["Axiom"]="https://github.com/pry0cc/axiom"
    ["Bhedak"]="https://github.com/almandin/fuxploider"
    ["CF-check"]="https://github.com/dwisiswant0/cf-check"
    ["Chaos"]="https://github.com/projectdiscovery/chaos-client"
    ["Cariddi"]="https://github.com/edoardottt/cariddi"
    ["Dalfox"]="https://github.com/hahwul/dalfox"
    ["DNSgen"]="https://github.com/ProjectAnte/dnsgen"
    ["Filter-resolved"]="https://github.com/tomnomnom/hacks/tree/master/filter-resolved"
    ["Findomain"]="https://github.com/Findomain/Findomain"
    ["Fuff"]="https://github.com/ffuf/ffuf"
    ["Freq"]="https://github.com/tomnomnom/hacks/tree/master/freq"
    ["Gargs"]="https://github.com/brentp/gargs"
    ["Gau"]="https://github.com/lc/gau"
    ["Gf"]="https://github.com/tomnomnom/gf"
    ["Github-Search"]="https://github.com/gwen001/github-search"
    ["Gospider"]="https://github.com/jaeles-project/gospider"
    ["Gowitness"]="https://github.com/sensepost/gowitness"
    ["Goop"]="https://github.com/deletescape/goop"
    ["GetJS"]="https://github.com/003random/getJS"
    ["Hakrawler"]="https://github.com/hakluke/hakrawler"
    ["HakrevDNS"]="https://github.com/hakluke/hakrevdns"
    ["Haktldextract"]="https://github.com/hakluke/haktldextract"
    ["Haklistgen"]="https://github.com/hakluke/haklistgen"
    ["Hudson Rock Free Cybercrime Intelligence Toolset"]="https://github.com/hudsonrock/toolset"
    ["Html-tool"]="https://github.com/tomnomnom/hacks/tree/master/html-tool"
    ["Httpx"]="https://github.com/projectdiscovery/httpx"
    ["Jaeles"]="https://github.com/jaeles-project/jaeles"
    ["Jsubfinder"]="https://github.com/ThreatUnkown/jsubfinder"
    ["Kxss"]="https://github.com/Emoe/kxss"
    ["Knoxss"]="https://github.com/knoxss/knoxss"
    ["Katana"]="https://github.com/projectdiscovery/katana"
    ["LinkFinder"]="https://github.com/GerbenJavado/LinkFinder"
    ["log4j-scan"]="https://github.com/fullhunt/log4j-scan"
    ["Metabigor"]="https://github.com/j3ssie/metabigor"
    ["MassDNS"]="https://github.com/blechschmidt/massdns"
    ["Naabu"]="https://github.com/projectdiscovery/naabu"
    ["Notify"]="https://github.com/projectdiscovery/notify"
    ["Paramspider"]="https://github.com/devanshbatham/ParamSpider"
    ["Qsreplace"]="https://github.com/tomnomnom/qsreplace"
    ["Rush"]="https://github.com/shenwei356/rush"
    ["SecretFinder"]="https://github.com/m4ll0k/SecretFinder"
    ["Shodan"]="https://github.com/achillean/shodan-python"
    ["ShuffleDNS"]="https://github.com/projectdiscovery/shuffledns"
    ["SQLMap"]="https://github.com/sqlmapproject/sqlmap"
    ["Subfinder"]="https://github.com/projectdiscovery/subfinder"
    ["SubJS"]="https://github.com/lc/subjs"
    ["Unew"]="https://github.com/dwisiswant0/unew"
    ["Unfurl"]="https://github.com/tomnomnom/unfurl"
    ["Urldedupe"]="https://github.com/lc/urldedupe"
    ["WaybackURLs"]="https://github.com/tomnomnom/waybackurls"
    ["Wingman"]="https://github.com/kingofhacker0/Wingman"
    ["Goop"]="https://github.com/deletescape/goop"
    ["Tojson"]="https://github.com/tomnomnom/hacks/tree/master/tojson"
    ["X8"]="https://github.com/ghsec/x8"
    ["xray"]="https://github.com/chaitin/xray"
    ["XSStrike"]="https://github.com/s0md3v/XSStrike"
    ["Page-fetch"]="https://github.com/detectify/page-fetch"
    ["HEDnsExtractor"]="https://github.com/pielco11/HEdnsExtractor"
)

# Function to Install a Tool
function install_tool() {
    local tool_name=$1
    local url=$2

    if command -v "${tool_name,,}" &>/dev/null; then
        echo -e "${GREEN}[+] ${tool_name} is already installed.${RESET}"
    elif [ -d "tools/$tool_name" ]; then
        echo -e "${GREEN}[+] ${tool_name} directory already exists. Skipping installation.${RESET}"
    else
        echo -e "${YELLOW}[+] Installing ${tool_name}...${RESET}"
        mkdir -p tools
        cd tools || exit 1
        git clone "$url" &>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "${RED}[!] Failed to clone ${tool_name}. Please check manually.${RESET}"
        else
            echo -e "${GREEN}[+] ${tool_name} installed successfully.${RESET}"
        fi
        cd ..
    fi
}

# Function to Install Go Tools via "go get"
function install_go_tool() {
    local tool_name=$1
    echo -e "${YELLOW}[+] Installing ${tool_name} using 'go get'...${RESET}"
    GO111MODULE=on go install "$tool_name" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] ${tool_name} installed successfully.${RESET}"
    else
        echo -e "${RED}[!] Failed to install ${tool_name}. Please check manually.${RESET}"
    fi
}

# Function to Install Tools via apt or pip if Available
function apt_pip_install() {
    local tool_name=$1
    echo -e "${YELLOW}[+] Installing ${tool_name} via package manager...${RESET}"
    if [[ "$tool_name" == "sqlmap" ]]; then
        sudo apt-get install sqlmap -y &>/dev/null
    elif [[ "$tool_name" == "shodan" ]]; then
        pip install shodan &>/dev/null
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] ${tool_name} installed successfully.${RESET}"
    else
        echo -e "${RED}[!] Failed to install ${tool_name} via package manager. Please check manually.${RESET}"
    fi
}

# Main Function to Install All Tools
function main() {
    print_banner

    for tool_name in "${!TOOLS[@]}"; do
        if [[ "$tool_name" == "SQLMap" ]] || [[ "$tool_name" == "Shodan" ]]; then
            apt_pip_install "$tool_name"
        elif [[ "$tool_name" == "Naabu" ]] || [[ "$tool_name" == "Httpx" ]] || [[ "$tool_name" == "Gf" ]]; then
            install_go_tool "${TOOLS[$tool_name]}"
        else
            install_tool "$tool_name" "${TOOLS[$tool_name]}"
        fi
    done

    echo -e "${GREEN}[+] All tools installation completed.${RESET}"
}

# Run the main function
main
