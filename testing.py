import os
import subprocess
from openai import ChatCompletion  # Importing OpenAI API to use GPT-4 model

# Dictionary of all the tools with their respective GitHub URLs
TOOLS = {
    "Reconator": "https://github.com/gokulapap/Reconator",
    "JSFScan.sh": "https://github.com/KathanP19/JSFScan.sh",
    "KingOfBugBountyTips": "https://github.com/KingOfBugbounty/KingOfBugBountyTips",
    "Amass": "https://github.com/OWASP/Amass",
    "Assetfinder": "https://github.com/tomnomnom/assetfinder",
    "Dalfox": "https://github.com/hahwul/dalfox",
    "Subfinder": "https://github.com/projectdiscovery/subfinder",
    "Naabu": "https://github.com/projectdiscovery/naabu",
    "WaybackURLs": "https://github.com/tomnomnom/waybackurls",
    "Httpx": "https://github.com/projectdiscovery/httpx",
    "XSStrike": "https://github.com/s0md3v/XSStrike",
    # Add other tools as needed
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


def deploy_reconator():
    """Deploy Reconator on Heroku for systemless recon."""
    if not os.path.exists("tools/Reconator"):
        print("Reconator not installed. Please install it first.")
        return

    os.chdir("tools/Reconator")
    print("Deploying Reconator on Heroku...")
    try:
        subprocess.run(["heroku", "create"], check=True)
        subprocess.run(["git", "push", "heroku", "main"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error deploying Reconator: {e}")
    os.chdir("../..")


def run_tool(tool, target):
    """Run a given tool against the target."""
    commands = {
        "Amass": f"amass enum -d {target} -o output/amass_{target}.txt",
        "Assetfinder": f"assetfinder --subs-only {target} > output/assetfinder_{target}.txt",
        "Dalfox": f"dalfox url {target} --waf-evasion --blind > output/dalfox_{target}.txt",
        "Subfinder": f"subfinder -d {target} -o output/subfinder_{target}.txt",
        "Naabu": f"naabu -host {target} -o output/naabu_{target}.txt",
        "WaybackURLs": f"echo {target} | waybackurls > output/waybackurls_{target}.txt",
        "Httpx": f"httpx -l output/subfinder_{target}.txt -o output/httpx_{target}.txt",
        "XSStrike": f"xsstrike -u {target} -l 5 > output/xsstrike_{target}.txt",
        # Add other tools as needed
    }

    command = commands.get(tool)
    if command:
        print(f"Running {tool} against target...")
        result = subprocess.run(command, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            print(f"{tool} run completed successfully.")
            print(f"Results saved to output/{tool}_{target}.txt")
        else:
            print(f"Error running {tool}: {result.stderr}")
    else:
        print(f"No automated command set up for {tool}. Please run it manually.")


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


def main():
    """Main function to run the recon and vulnerability checks."""
    # Print welcome message
    print("Welcome to Bug Bounty Recon Tool by kdairatchi!")
    print("This tool automates reconnaissance and vulnerability checks.")

    # Request target domain from user
    target = input("Enter the target domain (e.g., example.com): ")

    # Install all tools
    install_tools()

    # Deploy Reconator on Heroku
    deploy_reconator()

    # Create AI-generated cheatsheet
    create_cheatsheet_with_ai()

    # Run all tools against the target
    for tool in TOOLS:
        run_tool(tool, target)

    print("Automation complete. Check the output directory and cheatsheet for more information.")


if __name__ == "__main__":
    # Create output directory if it does not exist
    if not os.path.exists("output"):
        os.makedirs("output")

    # Run the main function
    main()
