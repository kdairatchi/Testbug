#!/bin/bash

# Color Variables
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
    echo "#            Bug Bounty Multitool by kdairatchi            #"
    echo "#                                                          #"
    echo "############################################################"
    echo -e "${RESET}"
}

# List of Tools to Install
TOOLS=(
    "https://github.com/lanmaster53/recon-ng"
    "https://github.com/projectdiscovery/httpx"
    "https://github.com/s0md3v/Arjun"
    "https://github.com/projectdiscovery/nuclei"
    "https://github.com/FortyNorthSecurity/EyeWitness"
)

PROXYCHAINS_COMMAND="proxychains4"

# Install Required Tools Function
function install_tools() {
    echo -e "${BLUE}[*] Installing Tools...${RESET}"
    mkdir -p tools
    cd tools || exit

    for url in "${TOOLS[@]}"; do
        tool_name=$(basename "$url" .git)
        if [ ! -d "$tool_name" ]; then
            echo -e "${YELLOW}[+] Installing ${tool_name}...${RESET}"
            git clone "$url"
        else
            echo -e "${GREEN}[+] ${tool_name} is already installed.${RESET}"
        fi
    done

    cd ..
}

# Run Tool Function
function run_tool() {
    local tool=$1
    local target_file=$2
    case $tool in
    "Recon-ng")
        echo -e "${CYAN}[+] Running Recon-ng against targets...${RESET}"
        ${PROXYCHAINS_COMMAND} python3 tools/recon-ng/recon-ng -i "${target_file}"
        ;;
    "httpx")
        echo -e "${CYAN}[+] Running httpx against targets...${RESET}"
        ${PROXYCHAINS_COMMAND} httpx -l "${target_file}"
        ;;
    "Arjun")
        echo -e "${CYAN}[+] Running Arjun against targets...${RESET}"
        ${PROXYCHAINS_COMMAND} python3 tools/Arjun/arjun.py -i "${target_file}"
        ;;
    "Nuclei")
        echo -e "${CYAN}[+] Running Nuclei against targets...${RESET}"
        ${PROXYCHAINS_COMMAND} nuclei -l "${target_file}"
        ;;
    "Eyewitness")
        echo -e "${CYAN}[+] Running EyeWitness to take screenshots of targets...${RESET}"
        ${PROXYCHAINS_COMMAND} python3 tools/EyeWitness/EyeWitness.py --input "${target_file}" --web
        ;;
    *)
        echo -e "${RED}[!] No automated command set up for ${tool}. Skipping...${RESET}"
        ;;
    esac
}

# Create a Cheatsheet Function
function display_cheatsheet() {
    if [ -f "cheatsheet.txt" ]; then
        echo -e "${YELLOW}[+] Displaying Cheatsheet...${RESET}"
        cat cheatsheet.txt
    else
        echo -e "${RED}[!] Cheatsheet not found. Please make sure it exists in the current directory.${RESET}"
    fi
}

# Main Execution Flow
print_banner

# Display Cheatsheet if it exists
display_cheatsheet

# Ask for target file
echo -e "${BLUE}[*] Please provide the path to the target file (e.g., targets.txt):${RESET}"
read -r target_file

# Check if target file exists
if [ ! -f "$target_file" ]; then
    echo -e "${RED}[!] Target file not found. Please provide a valid file.${RESET}"
    exit 1
fi

# Install Tools
install_tools

# Run Tools Against Target File
for tool_url in "${TOOLS[@]}"; do
    tool_name=$(basename "$tool_url" .git)
    run_tool "$tool_name" "$target_file"
done

# Completion Message
echo -e "${GREEN}[+] Automation complete. Check the output and refer to the cheatsheet for more information.${RESET}"
