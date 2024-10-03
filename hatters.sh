#!/bin/bash

# Color Variables for User-Friendly Experience
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
    echo "#             With AI-Generated Cheatsheets by kdairatchi  #"
    echo "#                                                          #"
    echo "############################################################"
    echo -e "${RESET}"
}

# List of Tools with GitHub URLs or Installation Instructions
declare -A TOOLS
TOOLS=(
    ["Amass"]="https://github.com/OWASP/Amass"
    ["Anew"]="https://github.com/tomnomnom/anew"
    ["Assetfinder"]="https://github.com/tomnomnom/assetfinder"
    ["Airixss"]="https://github.com/ferreiraklet/Airixss"
    ["Axiom"]="https://github.com/pry0cc/axiom"
    ["CF-check"]="https://github.com/dwisiswant0/cf-check"
    ["Chaos"]="https://github.com/projectdiscovery/chaos-client"
    ["Cariddi"]="https://github.com/edoardottt/cariddi"
    ["Dalfox"]="https://github.com/hahwul/dalfox"
    ["DNSgen"]="https://github.com/ProjectAnte/dnsgen"
    ["Findomain"]="https://github.com/Findomain/Findomain"
    ["Ffuf"]="https://github.com/ffuf/ffuf"
    ["Gau"]="https://github.com/lc/gau"
    ["Gf"]="https://github.com/tomnomnom/gf"
    ["Gospider"]="https://github.com/jaeles-project/gospider"
    ["Gowitness"]="https://github.com/sensepost/gowitness"
    ["GetJS"]="https://github.com/003random/getJS"
    ["Hakrawler"]="https://github.com/hakluke/hakrawler"
    ["Httpx"]="https://github.com/projectdiscovery/httpx"
    ["Jaeles"]="https://github.com/jaeles-project/jaeles"
    ["Kxss"]="https://github.com/Emoe/kxss"
    ["Knoxss"]="https://github.com/knoxss/knoxss"
    ["Katana"]="https://github.com/projectdiscovery/katana"
    ["LinkFinder"]="https://github.com/GerbenJavado/LinkFinder"
    ["log4j-scan"]="https://github.com/fullhunt/log4j-scan"
    ["MassDNS"]="https://github.com/blechschmidt/massdns"
    ["Naabu"]="https://github.com/projectdiscovery/naabu"
    ["Notify"]="https://github.com/projectdiscovery/notify"
    ["Paramspider"]="https://github.com/devanshbatham/ParamSpider"
    ["SecretFinder"]="https://github.com/m4ll0k/SecretFinder"
    ["Shodan"]="https://github.com/achillean/shodan-python"
    ["ShuffleDNS"]="https://github.com/projectdiscovery/shuffledns"
    ["SQLMap"]="https://github.com/sqlmapproject/sqlmap"
    ["Subfinder"]="https://github.com/projectdiscovery/subfinder"
    ["SubJS"]="https://github.com/lc/subjs"
    ["Unfurl"]="https://github.com/tomnomnom/unfurl"
    ["WaybackURLs"]="https://github.com/tomnomnom/waybackurls"
    ["Wingman"]="https://github.com/kingofhacker0/Wingman"
    ["X8"]="https://github.com/ghsec/x8"
    ["xray"]="https://github.com/chaitin/xray"
    ["XSStrike"]="https://github.com/s0md3v/XSStrike"
)

# Function to Install a Tool via Git Clone
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

# Function to Install Go Tools via "go install"
function install_go_tool() {
    local tool_name=$1
    echo -e "${YELLOW}[+] Installing ${tool_name} using 'go install'...${RESET}"
    GO111MODULE=on go install "$tool_name@latest" &>/dev/null
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

# Function to Display Cheatsheet Information for Each Tool
function generate_cheatsheet() {
    local tool_name=$1

    echo -e "${CYAN}############################################################${RESET}"
    echo -e "${YELLOW}[+] Cheatsheet for ${tool_name}:${RESET}"
    case $tool_name in
    "Amass")
        echo -e "Amass is used for DNS enumeration and finding subdomains.\nUsage: amass enum -d <target>\nExample: amass enum -d example.com"
        ;;
    "Assetfinder")
        echo -e "Assetfinder is used to find subdomains of a target.\nUsage: assetfinder --subs-only <target>\nExample: assetfinder --subs-only example.com"
        ;;
    "Dalfox")
        echo -e "Dalfox is a fast parameter analysis and XSS scanning tool.\nUsage: dalfox url <target>\nExample: dalfox url http://example.com"
        ;;
    "Httpx")
        echo -e "Httpx is used to probe for working HTTP and HTTPS servers.\nUsage: httpx -l <file>\nExample: httpx -l subdomains.txt"
        ;;
    "SQLMap")
        echo -e "SQLMap is used to automate SQL injection.\nUsage: sqlmap -u <url>\nExample: sqlmap -u http://example.com"
        ;;
    # Add cheatsheet content for other tools here...
    *)
        echo -e "No specific cheatsheet available for ${tool_name}."
        ;;
    esac
    echo -e "${CYAN}############################################################${RESET}"
}

# Main Function to Install All Tools and Show Cheatsheets
function main() {
    print_banner

    for tool_name in "${!TOOLS[@]}"; do
        # Handle different installation methods
        if [[ "$tool_name" == "SQLMap" ]] || [[ "$tool_name" == "Shodan" ]]; then
            apt_pip_install "$tool_name"
        elif [[ "$tool_name" == "Naabu" ]] || [[ "$tool_name" == "Httpx" ]] || [[ "$tool_name" == "Gf" ]]; then
            install_go_tool "${TOOLS[$tool_name]}"
        else
            install_tool "$tool_name" "${TOOLS[$tool_name]}"
        fi
        # Show cheatsheet for the tool after installation
        generate_cheatsheet "$tool_name"
    done

    echo -e "${GREEN}[+] All tools installation and cheatsheet generation completed.${RESET}"
}

# Run the main function
main
