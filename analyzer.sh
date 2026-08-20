#!/bin/bash

echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;36m   Advanced Network Security Analyzer    \e[0m"
echo -e "\e[1;36m=========================================\e[0m"
echo ""

read -p "Enter Target IP or Domain: " TARGET

# Input Validation
if ! [[ "$TARGET" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
    echo "[-] Error: Invalid IP address or subnet. Example: 192.168.1.1 or 192.168.1.0/24"
    exit 1
fi

echo "[*] Scanning $TARGET... Please wait."

# Nmap scan with proper quoting
nmap -sV -T4 "$TARGET" > raw_scan.txt

echo "[*] Scan complete. Generating HTML report..."

echo "<html><head><style>
body { background-color: #121212; color: #e0e0e0; font-family: Arial, sans-serif; padding: 20px; }
.critical { color: #ff4d4d; font-weight: bold; }
.warning { color: #ffb84d; font-weight: bold; }
.safe { color: #4dff4d; font-weight: bold; }
pre { background-color: #1e1e1e; padding: 15px; border-radius: 5px; overflow-x: auto; }
</style></head><body>
<h2>Network Security Scan Report</h2>
<p><b>Target:</b> $TARGET</p>
<p><b>Date:</b> $(date)</p>
<h3>Analysis Results:</h3>
<pre>" > report.html

# Fixed Loop with extended ports and single redirect
while IFS= read -r line; do
    if [[ $line == *"23/tcp"* ]] || [[ $line == *"21/tcp"* ]] || \
       [[ $line == *"445/tcp"* ]] || [[ $line == *"139/tcp"* ]] || \
       [[ $line == *"3389/tcp"* ]]; then
        echo "<span class='critical'>[CRITICAL] $line</span>"
    elif [[ $line == *"80/tcp"* ]] || [[ $line == *"8080/tcp"* ]] || \
         [[ $line == *"25/tcp"* ]] || [[ $line == *"110/tcp"* ]] || \
         [[ $line == *"3306/tcp"* ]]; then
        echo "<span class='warning'>[WARNING] $line</span>"
    elif [[ $line == *"open"* ]]; then
        echo "<span class='safe'>[OPEN] $line</span>"
    else
        echo "$line"
    fi
done < raw_scan.txt >> report.html

echo "</pre></body></html>" >> report.html

echo "[+] Report generated successfully as 'report.html'"
