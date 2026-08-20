# 🛡️ Advanced Network Security Analyzer

[![Python](https://img.shields.io/badge/Python-3.x-yellow.svg)](https://python.org)
[![Bash](https://img.shields.io/badge/Bash-Scripting-green.svg)](https://gnu.org/software/bash)
[![Tool](https://img.shields.io/badge/Tool-Nmap-blue.svg)](https://nmap.org)
[![License](https://img.shields.io/badge/License-MIT-white.svg)](LICENSE)

An automated, dual-language (Python & Bash) network reconnaissance tool
that runs Nmap scans, analyzes open ports for potential risks, and generates
a professional dark-themed HTML security report.

---

## ✨ Key Features

- **Dual Implementation:** Available in both Bash and Python.
- **Input Validation:** RegEx validation to ensure only valid IPv4/subnet targets.
- **Risk Profiling:** Categorizes ports into Critical 🔴, Warning 🟡, and Safe 🟢.
- **HTML Reporting:** Generates a clean dark-themed report automatically.

---

## 🚀 How to Run

### Bash version:
```bash
chmod +x analyzer.sh
sudo ./analyzer.sh
```
> After the scan completes, open the report in Firefox:
> ```bash
> firefox report.html &
> ```

### Python version:
```bash
sudo python3 py_analyzer.py
```
> After the scan completes, open the report in Firefox:
> ```bash
> firefox report.html &
> ```

---

## 📊 Risk Categories

| Level | Ports | Reason |
|-------|-------|--------|
| 🔴 Critical | 21 (FTP), 23 (Telnet), 445 (SMB), 3389 (RDP) | Highly exploitable protocols |
| 🟡 Warning  | 80 (HTTP), 8080, 25 (SMTP), 3306 (MySQL) | Commonly targeted services |
| 🟢 Safe     | Any other open port | No known critical risk |

---

## 🧠 How it Works

1. **Input Validation** — Verifies the target is a valid IPv4 or subnet.
2. **Reconnaissance** — Runs `nmap -sV` to detect open ports and services.
3. **Analysis** — Compares discovered ports against a threat matrix.
4. **Report** — Generates a color-coded HTML report for quick triage.

---

## ⚙️ Prerequisites

- Linux OS
- Python 3
- Nmap

```bash
sudo apt update && sudo apt install nmap -y
```

---

## ⚠️ Legal Notice

This tool is intended for **educational and authorized use only**.  
Only scan networks you own or have **explicit permission** to test.  
Unauthorized scanning may violate local laws.
