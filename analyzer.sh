#!/bin/bash

echo -e "\e[1;36m=========================================\e[0m"
echo -e "\e[1;36m   Advanced Network Security Analyzer    \e[0m"
echo -e "\e[1;36m=========================================\e[0m"
echo ""

read -r -p "Enter Target IP or Subnet: " TARGET

# Input Validation: format check, then every octet must be 0-255
# and the prefix (if any) must be 0-32.
if ! [[ "$TARGET" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})(/([0-9]{1,2}))?$ ]]; then
    echo "[-] Error: Invalid IP address or subnet. Example: 192.168.1.1 or 192.168.1.0/24"
    exit 1
fi
for i in 1 2 3 4; do
    if (( 10#${BASH_REMATCH[$i]} > 255 )); then
        echo "[-] Error: Each octet must be between 0 and 255."
        exit 1
    fi
done
if [[ -n "${BASH_REMATCH[6]}" ]] && (( 10#${BASH_REMATCH[6]} > 32 )); then
    echo "[-] Error: Subnet prefix must be between 0 and 32."
    exit 1
fi

echo "[*] Scanning $TARGET... Please wait."

if ! nmap -sV -T4 "$TARGET" > raw_scan.txt; then
    echo "[-] Nmap scan failed."
    exit 1
fi

echo "[*] Scan complete. Generating HTML report..."

echo "<html><head><meta charset='UTF-8'><style>
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

# Escape HTML special characters (service banners come from the scanned host).
escape_html() {
    local s=$1
    s=${s//&/&amp;}
    s=${s//</&lt;}
    s=${s//>/&gt;}
    printf '%s' "$s"
}

# Classify by the exact port number at the start of the line,
# so 2121 is never mistaken for 21 and 1080 never for 80.
while IFS= read -r line; do
    safe_line=$(escape_html "$line")
    if [[ $line =~ ^([0-9]+)/(tcp|udp)[[:space:]]+open[[:space:]] ]]; then
        case "${BASH_REMATCH[1]}" in
            21|23|139|445|3389)
                echo "<span class='critical'>[CRITICAL] $safe_line</span>" ;;
            25|80|110|3306|8080)
                echo "<span class='warning'>[WARNING] $safe_line</span>" ;;
            *)
                echo "<span class='safe'>[OPEN] $safe_line</span>" ;;
        esac
    else
        echo "$safe_line"
    fi
done < raw_scan.txt >> report.html

echo "</pre></body></html>" >> report.html

echo "[+] Report generated successfully as 'report.html'"
