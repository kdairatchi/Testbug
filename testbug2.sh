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

# API Initialization (Assuming API Key is set as an environment variable)
chat_completion = ChatCompletion(api_key=os.getenv('OPENAI_API_KEY'))


def install_tools():
    """Install all tools listed in the TOOLS dictionary."""
    os.makedirs("tools", exist_ok=True)
    os.chdir("tools")
    for tool, url in TOOLS.items():
        if not os.path.exists(tool):
            try:
                print(f"Installing {tool}...")
                subprocess.run(["git", "clone", url, tool], check=True)
            except subprocess.CalledProcessError:
                print(f"Failed to install {tool}. Please try installing it manually.")
        else:
            print(f"{tool} is already installed.")
    os.chdir("..")


def run_tool(tool, target_file, use_proxychains):
    """Run a given tool against the target file."""
    commands = {
        "Recon-ng": f"python3 tools/Recon-ng/recon-ng --target {target_file}",
        "httpx": f"httpx -l {target_file}",
        "Arjun": f"python3 tools/Arjun/arjun.py -i {target_file}",
        "Nmap": f"nmap -iL {target_file}",
        "Nuclei": f"nuclei -l {target_file}",
        # Additional tools can be added here as needed
    }

    command = commands.get(tool)
    if command:
        if use_proxychains:
            command = f"proxychains4 {command}"
        print(f"Running {tool}...")
        result = subprocess.run(command, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            handle_tool_output(tool, result.stdout)
        else:
            print(f"Error running {tool}: {result.stderr}")
    else:
        print(f"No automated command set up for {tool}. Please run it manually.")


def handle_tool_output(tool, output):
    """Handle the output of each tool by saving, displaying, or both."""
    print(f"\nOutput for {tool}:")
    print("1. Save to file")
    print("2. Display output")
    print("3. Both")
    choice = input("Choose an option (1/2/3): ")

    output_dir = "output"
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, f"{tool}_output.txt")

    if choice == "1":
        with open(output_file, "w") as f:
            f.write(output)
        print(f"Output saved to {output_file}")
    elif choice == "2":
        print(output)
    elif choice == "3":
        with open(output_file, "w") as f:
            f.write(output)
        print(f"Output saved to {output_file}")
        print(output)
    else:
        print("Invalid choice. Please enter 1, 2, or 3.")


def create_cheatsheet_with_ai():
    """Generate a cheatsheet for all tools using OpenAI's GPT-4 model."""
    cheatsheet_content = []

    for tool, url in TOOLS.items():
        try:
            response = chat_completion.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": f"Create a detailed cheatsheet for the following tool: {tool}. Include usage examples, command options, and explain briefly what it does."},
                ],
                max_tokens=500,
            )
            cheat_info = response['choices'][0]['message']['content']
            cheatsheet_content.append(f"Tool: {tool}\nURL: {url}\n{cheat_info}\n\n")
        except Exception as e:
            print(f"Failed to create cheatsheet for {tool}: {e}")
            cheatsheet_content.append(f"Tool: {tool}\nURL: {url}\nNo cheatsheet available due to an error.\n\n")

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

    # Ask if the user wants to use proxychains
    use_proxychains = input("Do you want to use proxychains for all commands? (yes/no): ").lower() == "yes"

    # Run all applicable tools against the targets
    for tool in TOOLS:
        run_tool(tool, target_file, use_proxychains)

    print("Automation complete. Check output and cheatsheet for more information.")
