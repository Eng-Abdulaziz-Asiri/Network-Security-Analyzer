# 🛡️ Network Security Analyzer

![Python](https://img.shields.io/badge/Python-3.x-yellow.svg)
![Bash](https://img.shields.io/badge/Bash-Scripting-green.svg)
![Nmap](https://img.shields.io/badge/Tool-Nmap-blue.svg)

A dual-language (Python & Bash) network reconnaissance tool that automates Nmap scans, categorizes open ports based on known threat vectors, and generates a responsive, dark-themed HTML security report.

*(Add Screenshot Here)*

## ✨ Key Features
- **Dual Implementation:** Available in both Bash and Python to suit different environments.
- **Input Validation:** Built-in RegEx validation to ensure only valid IPv4 addresses or subnets are accepted, preventing command execution errors.
- **Automated Risk Profiling:** Parses scan results and categorizes discovered ports into Critical (🔴), Warning (🟡), and Safe (🟢) tiers.
- **HTML Reporting:** Converts raw terminal output into a structured, readable web report.

## 🧠 How it Works (Under the Hood)
1. **Validation:** Verifies user input using Regular Expressions.
2. **Reconnaissance:** Executes an `nmap` service scan (`-sV`) against the target.
3. **Log Parsing:** Reads the raw output line by line, comparing open ports against a predefined threat matrix.
4. **Report Generation:** Wraps the analyzed data into an HTML template, applying CSS classes to highlight risky ports for quick triage.

## 🚀 How to Run

### 1. Clone the Repository
```bash
git clone [https://github.com/Eng-Abdulaziz-Asiri/Network-Security-Analyzer.git](https://github.com/Eng-Abdulaziz-Asiri/Network-Security-Analyzer.git)
cd Network-Security-Analyzer
