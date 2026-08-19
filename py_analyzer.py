import subprocess
import datetime

print("==========================================")
print("   Advanced Security Analyzer (Python)    ")
print("==========================================")

# طلب الهدف من المستخدم
target = input("[?] Enter Target IP or Subnet (Default: 127.0.0.1): ").strip()
if not target:
    target = "127.0.0.1"

print(f"[*] Starting Deep Scan on {target}...")
print("[*] Please wait. Python is orchestrating the scan...")

try:
    # تنفيذ فحص Nmap من داخل بايثون
    result = subprocess.run(['nmap', '-sV', '-T4', target], capture_output=True, text=True)
    scan_output = result.stdout

    print("[*] Scan complete. Analyzing risks and generating HTML...")

    # تجهيز كود HTML بتصميم حديث ومتقدم
    html_content = f"""<!DOCTYPE html>
    <html><head><title>Python Security Report</title>
    <style>
    body {{font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #0d1117; color: #c9d1d9;}}
    .container {{width: 85%; margin: auto; background: #161b22; padding: 25px; border-radius: 10px; border: 1px solid #30363d; margin-top: 30px;}}
    h2 {{color: #58a6ff; border-bottom: 1px solid #30363d; padding-bottom: 10px;}}
    .info {{background: #21262d; padding: 15px; border-radius: 5px; margin-bottom: 20px;}}
    .critical {{color: #ff7b72; font-weight: bold;}}
    .warning {{color: #d2a8ff; font-weight: bold;}}
    .safe {{color: #3fb950;}}
    pre {{background: #010409; padding: 15px; border-radius: 5px; overflow-x: auto; border: 1px solid #30363d; color: #c9d1d9; font-size: 14px;}}
    </style>
    </head><body><div class="container">
    <h2>🐍 Python-Powered Network Security Report</h2>
    <div class="info">
    <p><strong>🎯 Target:</strong> {target}</p>
    <p><strong>📅 Date:</strong> {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}</p>
    </div>
    <h3>📊 Scan Results & Python Analysis:</h3>
    <pre>
    """

    # تحليل النتائج سطراً بسطر باستخدام بايثون
    for line in scan_output.split('\n'):
        if "21/tcp" in line or "23/tcp" in line:
            html_content += f"<span class='critical'>[CRITICAL RISK] {line} (Unencrypted Protocol!)</span>\n"
        elif "80/tcp" in line:
            html_content += f"<span class='warning'>[WARNING] {line} (HTTP - Consider HTTPS)</span>\n"
        elif "open" in line:
            html_content += f"<span class='safe'>[OPEN] {line}</span>\n"
        else:
            html_content += f"{line}\n"

    html_content += "</pre></div></body></html>"

    # حفظ التقرير
    with open("python_report.html", "w", encoding="utf-8") as f:
        f.write(html_content)

    print("[+] Success! Python Report saved as 'python_report.html'")
    print("==========================================")

except Exception as e:
    print(f"[-] An error occurred: {e}")
    
