import os
import subprocess
from openai import ChatCompletion  # Importing OpenAI API to use GPT-4 model

# Dictionary of all the tools with their respective GitHub URLs
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

# API Initialization (Assuming API Key is set as an environment variable)
chat_completion = ChatCompletion(api_key=os.getenv('OPENAI_API_KEY'))

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

def run_tool(tool, target_file):
    commands = {
        "Recon-ng": f"{PROXYCHAINS_COMMAND} python3 tools/Recon-ng/recon-ng -i {target_file}",
        "httpx": f"{PROXYCHAINS_COMMAND} httpx -l {target_file}",
        "Arjun": f"{PROXYCHAINS_COMMAND} python3 tools/Arjun/arjun.py -i {target_file}",
        "Nmap": f"{PROXYCHAINS_COMMAND} nmap -iL {target_file}",
        "Nuclei": f"{PROXYCHAINS_COMMAND} nuclei -l {target_file}",
    }

    command = commands.get(tool)
    if command:
        print(f"Running {tool} against target file with proxychains...")
        os.system(command)
    else:
        print(f"No automated command set up for {tool}. Please run it manually.")

def create_cheatsheet_with_ai():
    cheatsheet_content = []

    for tool, url in TOOLS.items():
        response = chat_completion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": f"Create a detailed cheatsheet for the following tool: {tool}. Include usage examples, command options, and explain briefly what it does."},
            ],
            max_tokens=500,
        )
        cheat_info = response['choices'][0]['message']['content']
        cheatsheet_content.append(f"Tool: {tool}\nURL: {url}\n{cheat_info}\n\n")

    with open("cheatsheet.txt", "w") as f:
        f.writelines(cheatsheet_content)

    print("Cheatsheet created using AI: cheatsheet.txt")

if __name__ == "__main__":
    # Request target file from user
    target_file = input("Enter the path to the target file (e.g., targets.txt): ")

    # Check if target file exists
    if not os.path.exists(target_file):
        print("Target file not found. Please provide a valid file.")
        exit(1)

    # Install all tools
    install_tools()

    # Create an AI-generated cheatsheet
    create_cheatsheet_with_ai()

    # Run all applicable tools against the targets
    for tool in TOOLS:
        run_tool(tool, target_file)

    print("Automation complete. Check output and cheatsheet for more information.")
