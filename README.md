# 🛡️ Advanced Network Security Analyzer

![Python](https://img.shields.io/badge/Python-3.x-yellow.svg)
![Bash](https://img.shields.io/badge/Bash-Scripting-green.svg)
![Nmap](https://img.shields.io/badge/Tool-Nmap-blue.svg)

An automated, dual-language (Python & Bash) network reconnaissance tool that orchestrates Nmap scans, intelligently analyzes open ports for potential vulnerabilities, and generates a responsive, dark-themed HTML security report.

## ✨ Key Features
- **Dual Implementation:** Available in both pure Bash and Python to suit different environments.
- **Smart Input Validation:** Built-in RegEx validation to ensure only valid IPv4 addresses or subnets are scanned.
- **Automated Risk Profiling:** Intelligently categorizes discovered ports into Critical (🔴), Warning (🟡), and Safe (🟢) tiers based on known attack vectors.
- **Dynamic HTML Reporting:** Translates raw terminal output into a readable, professional web report automatically.

## 🧠 How it Works (Under the Hood)
1. **Input Validation:** The script first verifies the user's input using Regular Expressions (RegEx) to prevent command injection and ensure it's a valid IPv4 target.
2. **Reconnaissance:** It triggers an `nmap` service scan (`-sV`) against the verified target in the background.
3. **Log Parsing & Analysis:** The script parses the raw Nmap output line by line, comparing discovered open ports against a predefined threat matrix.
4. **Report Generation:** Finally, it wraps the analyzed data into a responsive HTML template, injecting CSS classes to highlight risky ports in red (Critical) or yellow (Warning) for quick triage.

## ⚙️ Prerequisites
Ensure you have the following installed on your Linux machine:
- `python3`
- `nmap`

*Install Nmap (if missing on Debian/Kali/Ubuntu):*
```bash
sudo apt update && sudo apt install nmap -y 
