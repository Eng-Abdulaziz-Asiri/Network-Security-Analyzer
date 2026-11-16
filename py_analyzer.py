import datetime
import html
import ipaddress
import subprocess
import sys
import xml.etree.ElementTree as ET

# Ports are matched by exact number, not by text search,
# so 2121 is never mistaken for 21 and 1080 never for 80.
CRITICAL_PORTS = {21: "FTP", 23: "Telnet", 139: "NetBIOS/SMB", 445: "SMB", 3389: "RDP"}
WARNING_PORTS = {25: "SMTP", 80: "HTTP", 110: "POP3", 3306: "MySQL", 8080: "HTTP-alt"}


def parse_target(text):
    """Return a valid IPv4 address/subnet as a string, or None."""
    try:
        return str(ipaddress.IPv4Network(text.strip(), strict=False)) if "/" in text \
            else str(ipaddress.IPv4Address(text.strip()))
    except ValueError:
        return None


def classify(port):
    if port in CRITICAL_PORTS:
        return "critical", "CRITICAL"
    if port in WARNING_PORTS:
        return "warning", "WARNING"
    return "safe", "OPEN"


def run_nmap(target):
    """Run Nmap and return its XML output (-oX -) as an ElementTree root."""
    result = subprocess.run(
        ["nmap", "-sV", "-T4", "-oX", "-", target],
        capture_output=True, text=True, check=True,
    )
    return ET.fromstring(result.stdout)


def open_ports(root):
    """Yield (host, port, proto, service) for every open port in the scan."""
    for host in root.findall("host"):
        addr = host.find("address").get("addr")
        for port in host.findall("ports/port"):
            if port.find("state").get("state") != "open":
                continue
            svc = port.find("service")
            parts = []
            if svc is not None:
                parts = [svc.get(k) for k in ("name", "product", "version") if svc.get(k)]
            yield addr, int(port.get("portid")), port.get("protocol"), " ".join(parts) or "unknown"


def build_report(target, findings):
    counts = {"CRITICAL": 0, "WARNING": 0, "OPEN": 0}
    rows = []
    for addr, port, proto, service in findings:
        css, level = classify(port)
        counts[level] += 1
        # Service banners come from the scanned host, so escape them before
        # putting them in HTML (prevents HTML/script injection in the report).
        rows.append(
            f"<tr class='{css}'><td>[{level}]</td><td>{port}/{proto}</td>"
            f"<td>{html.escape(addr)}</td><td>{html.escape(service)}</td></tr>"
        )
    if not rows:
        rows.append("<tr><td colspan='4'>No open ports found.</td></tr>")

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Security Report</title>
<style>
  body {{ background-color: #0d1117; color: #c9d1d9; font-family: 'Courier New', Courier, monospace; padding: 20px; }}
  h1 {{ color: #58a6ff; }}
  table {{ border-collapse: collapse; width: 100%; background-color: #161b22; }}
  th, td {{ border: 1px solid #30363d; padding: 8px 10px; text-align: left; }}
  .critical td {{ color: #f85149; font-weight: bold; }}
  .warning td {{ color: #d29922; font-weight: bold; }}
  .safe td {{ color: #2ea043; }}
</style>
</head>
<body>
<h1>🛡️ Automated Security Analysis</h1>
<p><strong>Target:</strong> {html.escape(target)}</p>
<p><strong>Scan Date:</strong> {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
<p><strong>Summary:</strong> {counts['CRITICAL']} critical, {counts['WARNING']} warning, {counts['OPEN']} other open</p>
<table>
<tr><th>Level</th><th>Port</th><th>Host</th><th>Service</th></tr>
{chr(10).join(rows)}
</table>
</body>
</html>
"""


def main():
    print("\033[1;36m=========================================\033[0m")
    print("\033[1;36m Python Network Security Analyzer v3.0   \033[0m")
    print("\033[1;36m=========================================\033[0m\n")

    target = parse_target(input("Enter Target IP or Subnet: "))
    if target is None:
        print("[-] Error: Invalid IPv4 address or subnet. Example: 192.168.1.1 or 192.168.1.0/24")
        sys.exit(1)

    print(f"[*] Initializing Nmap scan against {target}...")
    try:
        root = run_nmap(target)
    except FileNotFoundError:
        print("[-] Error: Nmap is not installed. Run 'sudo apt install nmap'")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"[-] Nmap scan failed: {e.stderr.strip() or e}")
        sys.exit(1)
    except ET.ParseError:
        print("[-] Could not read Nmap's XML output.")
        sys.exit(1)

    findings = sorted(open_ports(root), key=lambda f: (f[0], f[1]))
    print("[*] Scan finished successfully.")
    for addr, port, proto, service in findings:
        print(f"    [{classify(port)[1]}] {addr} {port}/{proto} {service}")

    with open("python_report.html", "w", encoding="utf-8") as f:
        f.write(build_report(target, findings))
    print("[+] HTML report generated as 'python_report.html'")


if __name__ == "__main__":
    main()
