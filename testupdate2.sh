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
    echo "#            Bug Bounty Multitool by kdairatchi            #"
    echo "#                                                          #"
    echo "############################################################"
    echo -e "${RESET}"
}

# List of Tools with GitHub URLs for Installation
TOOLS=(
    "https://github.com/gokulapap/Reconator"
    "https://github.com/KathanP19/JSFScan.sh"
    "https://github.com/KingOfBugbounty/KingOfBugBountyTips"
    "https://github.com/OWASP/Amass"
    "https://github.com/tomnomnom/assetfinder"
    "https://github.com/hahwul/dalfox"
    "https://github.com/projectdiscovery/subfinder"
    "https://github.com/projectdiscovery/naabu"
    "https://github.com/tomnomnom/waybackurls"
    "https://github.com/projectdiscovery/httpx"
    "https://github.com/s0md3v/XSStrike"
)

# Tool Installation Function
function install_tools() {
    echo -e "${BLUE}[*] Installing necessary tools...${RESET}"
    mkdir -p tools
    cd tools || exit 1

    for url in "${TOOLS[@]}"; do
        tool_name=$(basename "$url" .git)
        if [ ! -d "$tool_name" ]; then
            echo -e "${YELLOW}[+] Installing ${tool_name}...${RESET}"
            git clone "$url" &>/dev/null
            if [ $? -ne 0 ]; then
                echo -e "${RED}[!] Failed to install ${tool_name}. Please check manually.${RESET}"
            else
                echo -e "${GREEN}[+] ${tool_name} installed successfully.${RESET}"
            fi
        else
            echo -e "${GREEN}[+] ${tool_name} is already installed.${RESET}"
        fi
    done

    cd ..
}

# Generate Cheatsheet Function
function generate_cheatsheet() {
    echo -e "${BLUE}[*] Generating AI-like cheatsheet for tools...${RESET}"
    if [ ! -f "cheatsheet.txt" ]; then
        touch cheatsheet.txt
        # Example simulated AI content for demonstration purposes
        cat <<EOF >cheatsheet.txt
Tool: Amass
Usage: amass enum -d <target>
Description: Amass is used for DNS enumeration and finding subdomains.
Example: amass enum -d example.com

Tool: Assetfinder
Usage: assetfinder --subs-only <target>
Description: Assetfinder is used to find subdomains of a given target.
Example: assetfinder --subs-only example.com

Tool: Dalfox
Usage: dalfox url <target>
Description: Dalfox is a fast parameter analysis and XSS scanning tool.
Example: dalfox url http://example.com

Tool: Subfinder
Usage: subfinder -d <target>
Description: Subfinder is a tool for discovering subdomains.
Example: subfinder -d example.com

Tool: Naabu
Usage: naabu -host <target>
Description: Naabu is a fast port scanning tool.
Example: naabu -host example.com

Tool: WaybackURLs
Usage: echo <target> | waybackurls
Description: WaybackURLs fetches URLs from the Wayback Machine.
Example: echo example.com | waybackurls

Tool: Httpx
Usage: httpx -l <file>
Description: Httpx is used to probe for working HTTP and HTTPS servers.
Example: httpx -l subdomains.txt

Tool: XSStrike
Usage: xsstrike -u <target>
Description: XSStrike is used to scan for XSS vulnerabilities.
Example: xsstrike -u http://example.com
EOF
        echo -e "${GREEN}[+] Cheatsheet generated successfully.${RESET}"
    else
        echo -e "${GREEN}[+] Cheatsheet already exists.${RESET}"
    fi
}

# Display Cheatsheet Function
function display_cheatsheet() {
    local tool=$1
    echo -e "${YELLOW}[+] Displaying cheatsheet for ${tool}...${RESET}"
    if [ -f "cheatsheet.txt" ]; then
        grep -A 10 -i "Tool: ${tool}" cheatsheet.txt
    else
        echo -e "${RED}[!] Cheatsheet not found. Please make sure cheatsheet.txt exists in the current directory.${RESET}"
    fi
}

# Run Tool Function
function run_tool() {
    local tool=$1
    local target=$2
    local output_dir="output"
    mkdir -p "${output_dir}"
    local output_file="${output_dir}/${tool}_output.txt"

    case $tool in
    "Amass")
        command="amass enum -d ${target} -o ${output_file}"
        ;;
    "Assetfinder")
        command="assetfinder --subs-only ${target} > ${output_file}"
        ;;
    "Dalfox")
        command="dalfox url ${target} --waf-evasion --blind > ${output_file}"
        ;;
    "Subfinder")
        command="subfinder -d ${target} -o ${output_file}"
        ;;
    "Naabu")
        command="naabu -host ${target} -o ${output_file}"
        ;;
    "WaybackURLs")
        command="echo ${target} | waybackurls > ${output_file}"
        ;;
    "Httpx")
        command="httpx -l ${output_file} -o ${output_file}"
        ;;
    "XSStrike")
        command="xsstrike -u ${target} -l 5 > ${output_file}"
        ;;
    *)
        echo -e "${RED}[!] No automated command set up for ${tool}. Skipping...${RESET}"
        return
        ;;
    esac

    # Display cheatsheet before running the tool
    display_cheatsheet "${tool}"

    # Execute the command
    echo -e "${CYAN}[+] Running ${tool}...${RESET}"
    eval "${command}"

    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] ${tool} run completed successfully. Results saved to ${output_file}${RESET}"
    else
        echo -e "${RED}[!] Error running ${tool}. Please check manually.${RESET}"
    fi
}

# Summary Function for Results
function summarize_results() {
    echo -e "${BLUE}[*] Generating summary of results...${RESET}"
    local output_dir="output"
    if [ -d "${output_dir}" ]; then
        echo -e "${CYAN}Summary of results:${RESET}"
        for file in ${output_dir}/*; do
            echo -e "${YELLOW}Results from $(basename "${file}" .txt):${RESET}"
            head -n 10 "${file}"
            echo -e "${CYAN}... [Truncated, see ${file} for complete results]${RESET}\n"
        done
    else
        echo -e "${RED}[!] Output directory not found.${RESET}"
    fi
}

# Main Function to Run Reconnaissance
function main() {
    print_banner

    # Get target domain from user
    echo -e "${BLUE}[*] Enter the target domain (e.g., example.com):${RESET}"
    read -r target

    if [ -z "$target" ]; then
        echo -e "${RED}[!] No target entered. Exiting.${RESET}"
        exit 1
    fi

    # Install all required tools
    install_tools

    # Generate cheatsheet if not available
    generate_cheatsheet

    # Run each tool against the target
    for url in "${TOOLS[@]}"; do
        tool_name=$(basename "$url" .git)
        run_tool "${tool_name}" "${target}"
    done

    # Summarize results after running all tools
    summarize_results

    echo -e "${GREEN}[+] Reconnaissance complete. Check the output directory for full results.${RESET}"
}

# Run the main function
main
