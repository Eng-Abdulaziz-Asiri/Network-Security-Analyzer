#!/bin/bash
# =========================================================
#  Network Security Analyzer - Easy Launcher
#  One command to check prerequisites, run a scan, and
#  open the report. No manual setup required.
#
#  Usage: bash run.sh
# =========================================================
 
set -e
 
CYAN='\e[1;36m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
RESET='\e[0m'
 
echo -e "${CYAN}=========================================${RESET}"
echo -e "${CYAN}   Network Security Analyzer - Launcher   ${RESET}"
echo -e "${CYAN}=========================================${RESET}"
echo ""
 
# Always run from this script's own directory, regardless of
# where the user calls it from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
 
# Use sudo only if we're not already root (e.g. inside some containers).
SUDO=""
if [[ "$(id -u)" -ne 0 ]]; then
    SUDO="sudo"
fi
 
# 1) OS check
if [[ "$(uname)" != "Linux" ]]; then
    echo -e "${RED}[-] This tool only runs on Linux.${RESET}"
    exit 1
fi
 
# 2) Check / install Nmap automatically
if ! command -v nmap &> /dev/null; then
    echo -e "${YELLOW}[!] Nmap not found. Installing it now...${RESET}"
    if command -v apt &> /dev/null; then
        $SUDO apt update && $SUDO apt install -y nmap
    elif command -v dnf &> /dev/null; then
        $SUDO dnf install -y nmap
    elif command -v pacman &> /dev/null; then
        $SUDO pacman -Sy --noconfirm nmap
    else
        echo -e "${RED}[-] Could not detect a supported package manager.${RESET}"
        echo -e "${RED}    Please install nmap manually, then re-run this script.${RESET}"
        exit 1
    fi
else
    echo -e "${GREEN}[+] Nmap is already installed.${RESET}"
fi
 
echo ""
echo "Choose which version to run:"
echo "  1) Python (recommended)"
echo "  2) Bash (lightweight)"
read -p "Choice [1]: " choice
choice=${choice:-1}
echo ""
 
if [[ "$choice" == "2" ]]; then
    chmod +x analyzer.sh
    $SUDO ./analyzer.sh
    REPORT="report.html"
else
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}[-] python3 not found. Install it, or choose the Bash version instead.${RESET}"
        exit 1
    fi
    $SUDO python3 py_analyzer.py
    REPORT="python_report.html"
fi
 
# 3) Open the report automatically
echo ""
if [[ -f "$REPORT" ]]; then
    echo -e "${GREEN}[+] Report generated: $REPORT${RESET}"
    if command -v xdg-open &> /dev/null; then
        xdg-open "$REPORT" &> /dev/null &
    elif command -v firefox &> /dev/null; then
        firefox "$REPORT" &> /dev/null &
    else
        echo "Open $REPORT manually in your browser."
    fi
else
    echo -e "${RED}[-] Report file was not found.${RESET}"
fi
 
