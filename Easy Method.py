import subprocess
print(f"{'Wi-Fi Name':<30} | Password")
print("-" * 45)
profiles = subprocess.getoutput("netsh wlan show profiles")
profiles = [line.split(":")[1].strip() for line in profiles.splitlines() if "All User Profile" in line]

for name in profiles:
    result = subprocess.getoutput(f"netsh wlan show profile \"{name}\" key=clear")
    pwd_lines = [line for line in result.splitlines() if "Key Content" in line]
    password = pwd_lines[0].split(":")[1].strip() if pwd_lines else ""
    print(f"{name:<30} | {password}")
input("\nPress Enter to exits...")
