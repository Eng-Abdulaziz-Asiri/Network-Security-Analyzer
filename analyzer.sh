#!/bin/bash

echo "=========================================="
echo "   Advanced Network Security Analyzer     "
echo "=========================================="

# 1. التفاعل مع المستخدم لطلب الهدف
read -p "[?] Enter Target IP or Subnet (e.g., 127.0.0.1): " TARGET

# إذا لم يكتب المستخدم شيئاً، نستخدم الجهاز المحلي كافتراضي
if [ -z "$TARGET" ]; then
    TARGET="127.0.0.1"
    echo "[-] No target provided. Defaulting to $TARGET"
fi

echo "[*] Starting Deep Scan (Versions & OS detection) on $TARGET..."
echo "[*] This might take a minute... Please wait..."

# 2. فحص متقدم لاكتشاف الإصدارات والخدمات (-sV)
nmap -sV -T4 $TARGET > raw_scan.txt

echo "[*] Analyzing risks and generating advanced HTML report..."

# 3. بناء تقرير HTML متقدم بتصميم ليلي احترافي (Dark Mode)
cat << 'EOF' > report.html
<!DOCTYPE html><html><head><title>Advanced Security Report</title>
<style>
body {font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #1e1e1e; color: #d4d4d4;}
.container {width: 85%; margin: auto; background: #252526; padding: 25px; border-radius: 10px; box-shadow: 0px 4px 15px rgba(0,0,0,0.5); margin-top: 30px;}
h2 {color: #4daafc; border-bottom: 1px solid #333; padding-bottom: 10px;}
.info {background: #2d2d30; padding: 15px; border-radius: 5px; margin-bottom: 20px;}
.critical {color: #f14c4c; font-weight: bold;}
.warning {color: #cca700; font-weight: bold;}
.safe {color: #89d185;}
pre {background: #1e1e1e; padding: 15px; border-radius: 5px; overflow-x: auto; border: 1px solid #333; color: #d4d4d4;}
</style>
</head><body><div class="container">
<h2>🛡️ Advanced Network Security Scan & Risk Assessment</h2>
EOF

echo "<div class='info'>" >> report.html
echo "<p><strong>🎯 Target:</strong> $TARGET</p>" >> report.html
echo "<p><strong>📅 Date:</strong> $(date)</p>" >> report.html
echo "</div>" >> report.html

echo "<h3>📊 Scan Results & Vulnerability Analysis:</h3>" >> report.html
echo "<pre>" >> report.html

# 4. تحليل المخاطر: قراءة النتائج وتلوين الثغرات تلقائياً
while IFS= read -r line; do
    if [[ $line == *"23/tcp"* ]] || [[ $line == *"21/tcp"* ]]; then
        echo "<span class='critical'>[CRITICAL RISK] $line (Unencrypted Protocol - Highly Vulnerable!)</span>" >> report.html
    elif [[ $line == *"80/tcp"* ]]; then
        echo "<span class='warning'>[WARNING] $line (HTTP is unencrypted, consider HTTPS)</span>" >> report.html
    elif [[ $line == *"open"* ]]; then
        echo "<span class='safe'>[OPEN] $line</span>" >> report.html
    else
        echo "$line" >> report.html
    fi
done < raw_scan.txt >> report.html

echo "</pre></div></body></html>" >> report.html

echo "[+] Scan and Analysis Completed!"
echo "[+] Advanced Report saved as report.html"
echo "=========================================="
