import subprocess
import datetime
import re
import sys

def is_valid_target(target):
    pattern = r'^(\d{1,3}\.){3}\d{1,3}(/\d{1,2})?$'
    return re.match(pattern, target)

print("\033[1;36m=========================================\033[0m")
print("\033[1;36m Python Network Security Analyzer v2.0   \033[0m")
print("\033[1;36m=========================================\033[0m\n")

target = input("Enter Target IP or Subnet: ")

if not is_valid_target(target):
    print("[-] Error: Invalid IP address. Example: 192.168.1.1")
    sys.exit(1)

print(f"[*] Initializing Nmap scan against {target}...")

try:
    result = subprocess.run(['nmap', '-sV', '-T4', target], capture_output=True, text=True, check=True)
    scan_output = result.stdout
    print("[*] Scan finished successfully.")
except subprocess.CalledProcessError as e:
    print(f"[-] Nmap scan failed: {e}")
    sys.exit(1)
except FileNotFoundError:
    print("[-] Error: Nmap is not installed. Run 'sudo apt install nmap'")
    sys.exit(1)

html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Security Report</title>
    <style>
        body {{ background-color: #0d1117; color: #c9d1d9; font-family: 'Courier New', Courier, monospace; padding: 20px; }}
        h1 {{ color: #58a6ff; }}
        .critical {{ color: #f85149; font-weight: bold; background-color: rgba(248,81,73,0.1); padding: 2px 5px; border-radius: 3px;}}
        .warning {{ color: #d29922; font-weight: bold; background-color: rgba(210,153,34,0.1); padding: 2px 5px; border-radius: 3px;}}
        .safe {{ color: #2ea043; font-weight: bold; }}
        pre {{ background-color: #161b22; padding: 15px; border: 1px solid #30363d; border-radius: 6px; overflow-x: auto; line-height: 1.5;}}
    </style>
</head>
<body>
    <h1>🛡️ Automated Security Analysis</h1>
    <p><strong>Target:</strong> {target}</p>
    <p><strong>Scan Date:</strong> {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
    <pre>
"""

critical_ports = ["21/tcp", "23/tcp", "445/tcp", "139/tcp", "3389/tcp"]
warning_ports  = ["80/tcp", "8080/tcp", "25/tcp", "110/tcp", "3306/tcp"]

for line in scan_output.split('\n'):
    if any(p in line for p in critical_ports):
        html_content += f"<span class='critical'>[CRITICAL] {line}</span>\n"
    elif any(p in line for p in warning_ports):
        html_content += f"<span class='warning'>[WARNING] {line}</span>\n"
    elif "open" in line:
        html_content += f"<span class='safe'>[OPEN] {line}</span>\n"
    else:
        html_content += f"{line}\n"

html_content += """
    </pre>
</body>
</html>
"""

with open('python_report.html', 'w') as f:
    f.write(html_content)

print("[+] Secure HTML report generated as 'python_report.html'")
