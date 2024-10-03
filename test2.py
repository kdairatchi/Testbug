import os
import subprocess

TOOLS = {
    "Recon-ng": "https://github.com/lanmaster53/recon-ng",
    "httpx": "https://github.com/projectdiscovery/httpx",
    "isup.sh": "https://github.com/lord63/isup",
    "Arjun": "https://github.com/s0md3v/Arjun",
    "jSQL": "https://github.com/ron190/jsql-injection",
    "Smuggler": "https://github.com/defparam/smuggler",
    "Sn1per": "https://github.com/1N3/Sn1per",
    "Spiderfoot": "https://github.com/smicallef/spiderfoot",
    "Nuclei": "https://github.com/projectdiscovery/nuclei",
    "Jaeles": "https://github.com/jaeles-project/jaeles",
    "ChopChop": "https://github.com/michelin/ChopChop",
    "Inception": "https://github.com/insecurityofthings/inception",
    "Eyewitness": "https://github.com/FortyNorthSecurity/EyeWitness",
    "Meg": "https://github.com/tomnomnom/meg",
    "Gau": "https://github.com/lc/gau",
    "Snallygaster": "https://github.com/hannob/snallygaster",
    "Nmap": "https://nmap.org/download.html",
    "Waybackurls": "https://github.com/tomnomnom/waybackurls",
    "Gotty": "https://github.com/yudai/gotty",
    "GF": "https://github.com/tomnomnom/gf",
    "GF Patterns": "https://github.com/1ndianl33t/Gf-Patterns",
    "Paramspider": "https://github.com/devanshbatham/ParamSpider",
    "XSSER": "https://github.com/epsylon/xsser",
    "UPDOG": "https://github.com/sc0tfree/updog",
    "JSScanner": "https://github.com/0x240x23elu/JSScanner",
    "Takeover": "https://github.com/m4ll0k/takeover",
    "Keyhacks": "https://github.com/streaak/keyhacks",
    "S3 Bucket AIO Pwn": "https://github.com/andresriancho/enumerate-iam",
    "BHEH Sub Pwner Recon": "https://github.com/bhemmanuel/sub-pwner-recon",
    "GitLeaks": "https://github.com/zricethezav/gitleaks",
    "Domain-2IP-Converter": "https://github.com/basil00/Domain-2IP",
    "Dalfox": "https://github.com/hahwul/dalfox",
    "Log4j Scanner": "https://github.com/fullhunt/log4j-scan",
    "Osmedeus": "https://github.com/j3ssie/Osmedeus",
    "getJS": "https://github.com/003random/getJS",
    "Amass": "https://github.com/OWASP/Amass",
}

PROXYCHAINS_COMMAND = "proxychains4"

def install_tools():
    os.makedirs("tools", exist_ok=True)
    os.chdir("tools")
    for tool, url in TOOLS.items():
        if not os.path.exists(tool):
            try:
                print(f"Installing {tool}...")
                if "https" in url:
                    subprocess.run(["git", "clone", url, tool], check=True)
                else:
                    print(f"Manual installation required for {tool}. URL: {url}")
            except subprocess.CalledProcessError:
                print(f"Failed to install {tool}. Please try installing it manually.")
    os.chdir("..")

def run_tool(tool, target):
    commands = {
        "Recon-ng": f"{PROXYCHAINS_COMMAND} python3 tools/Recon-ng/recon-ng --target {target}",
        "httpx": f"{PROXYCHAINS_COMMAND} httpx -u {target}",
        "Arjun": f"{PROXYCHAINS_COMMAND} python3 tools/Arjun/arjun.py -u {target}",
        "Nmap": f"{PROXYCHAINS_COMMAND} nmap {target}",
        "Nuclei": f"{PROXYCHAINS_COMMAND} nuclei -u {target}",
    }

    command = commands.get(tool)
    if command:
        print(f"Running {tool} against {target} with proxychains...")
        os.system(command)
    else:
        print(f"No automated command set up for {tool}. Please run it manually.")

def create_cheatsheet():
    with open("cheatsheet.txt", "w") as f:
        for tool, url in TOOLS.items():
            f.write(f"Tool: {tool}\nURL: {url}\nUsage:\n")
            if tool in ("Recon-ng", "httpx", "Arjun", "Nmap", "Nuclei"):
                f.write(f"Example command for {tool}:\n{PROXYCHAINS_COMMAND} {tool} -u <target>\n\n")
            else:
                f.write("Manual execution required.\n\n")

if __name__ == "__main__":
    target = input("Enter the target (e.g., example.com): ")

    # Install all tools
    install_tools()

    # Create a cheatsheet
    create_cheatsheet()
    print("Cheatsheet created: cheatsheet.txt")

    # Run all applicable tools against the target
    for tool in TOOLS:
        run_tool(tool, target)

    print("Automation complete. Check output and cheatsheet for more information.")
