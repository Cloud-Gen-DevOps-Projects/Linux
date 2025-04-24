#!/bin/bash

# Define colors
COLORS=('\033[1;31m' '\033[1;32m' '\033[1;33m' '\033[1;34m' '\033[1;35m' '\033[1;36m' '\033[1;37m')
NC='\033[0m' # No Color

# Script Overview (with random colors)
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}========================================${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}📋 Script Overview:${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}========================================${NC}"

echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}This script provides a complete system report and health check.${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}It performs the following tasks:${NC}"
echo ""

echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 1. Display OS Information (OS Name, Version, Kernel)${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 2. Show CPU Information (Total Cores, CPU Usage)${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 3. Check and Install Required Packages (curl, wget, net-tools, ethtool)${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 4. Display Memory Usage and Threshold Check${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 5. Show System Summary (Processes, Uptime, Zombie processes, etc.)${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 6. Display Disk Usage and Threshold Check${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 7. Show Top 5 Processes by CPU and Memory Usage${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 8. Display Active Network Interfaces and IPs${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]} 9. Check Internet Connectivity${NC}"
echo ""

echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}========================================${NC}"
echo -e "${COLORS[$RANDOM % ${#COLORS[@]}]}👉 Press Enter to begin system check...${NC}"
read

# Author: Ravindra Thota
# Version: 1.0
# Compatible with Linux-based systems (Ubuntu, CentOS, Debian, etc.)
# ==================================================

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BLINK='\033[5m'
NOBLINK='\033[25m'

# Header
clear
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}🌐 Namaskaram 🙏 Welcome to Cloud Gen Softech${NC}"
echo -e "${CYAN}📅 Date: $(date '+%Y-%m-%d') 🕒 Time: $(date '+%H:%M:%S')${NC}"
echo -e "${MAGENTA}👨‍💻 Author: Ravindra Thota${NC}"
echo -e "${YELLOW}Compatible with Linux-based systems (Ubuntu, CentOS, Debian, etc.)${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""
echo -e "${RED}⚠️  This script runs with a time delay between sections. Please DO NOT INTERRUPT until the cursor is released.${NC}"
echo -e "${BLUE}👉 Press Enter to begin and wait 5 Seconds for the first block execution...${NC}"
read

# Step 1 - OS Info
sleep 5
echo -e "${BLINK}${BLUE}🖥️ OS Information${NC}${NOBLINK}"
echo "========================================"
if [ -f /etc/os-release ]; then
    OS_NAME=$(grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')
    OS_VERSION=$(grep '^VERSION_ID' /etc/os-release | cut -d= -f2 | tr -d '"')
else
    OS_NAME="Unknown"
    OS_VERSION="Unknown"
fi
KERNEL_VERSION=$(uname -r)
echo -e "OS Name        : ${CYAN}${OS_NAME}${NC}"
echo -e "OS Version     : ${CYAN}${OS_VERSION}${NC}"
echo -e "Kernel Version : ${CYAN}${KERNEL_VERSION}${NC}"
echo ""

# Step 2 - CPU Info
sleep 6
echo -e "${BLINK}${YELLOW}🖥️ CPU Information${NC}${NOBLINK}"
echo "========================================"
TOTAL_CORES=$(nproc)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')
CPU_USAGE=$(awk "BEGIN {printf \"%.1f\", 100 - ${CPU_IDLE}}")
CPU_FREE=$(awk "BEGIN {printf \"%.1f\", ${CPU_IDLE}}")
echo -e "Total Allocated Processors : ${GREEN}${TOTAL_CORES}${NC}"
echo -ne "Used Processors           : ${RED}${CPU_USAGE}% ${WHITE}"
awk -v val=${CPU_USAGE} 'BEGIN {for(i=0;i<val/10;i++) printf "▓"}'; echo -e "${NC}"
echo -ne "Free Processors           : ${CYAN}${CPU_FREE}% ${WHITE}"
awk -v val=${CPU_FREE} 'BEGIN {for(i=0;i<val/10;i++) printf "░"}'; echo -e "${NC}"
echo ""

# CPU Threshold Check
echo -e "${BLINK}${BLUE}🖥️ CPU Usage Threshold Check${NC}${NOBLINK}"
echo "========================================"
if (( $(echo "$CPU_USAGE > 85" | bc -l) )); then
    echo -e "${RED}[WARNING] CPU usage is above 85%!${NC}"
else
    echo -e "${GREEN}[INFO] CPU usage is within acceptable limits.${NC}"
fi
echo ""

# Step 3 - Package Check
echo -e "${BLINK}${YELLOW}📦 Checking Required Packages${NC}${NOBLINK}"
echo "========================================"
REQUIRED_PACKAGES=(curl wget net-tools ethtool)
MISSING=()
for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v $pkg &> /dev/null; then
        echo -e "${RED}[MISSING] $pkg is not installed.${NC}"
        MISSING+=("$pkg")
    else
        echo -e "${GREEN}[OK] $pkg is installed.${NC}"
    fi
done
if [ ${#MISSING[@]} -ne 0 ]; then
    echo ""
    echo -e "${YELLOW}Installing missing packages: ${MISSING[@]}${NC}"
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y ${MISSING[@]}
    elif command -v yum &> /dev/null; then
        sudo yum install -y ${MISSING[@]}
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y ${MISSING[@]}
    fi
fi
echo ""

# Step 4 - Memory Usage
sleep 6
echo -e "${BLINK}${MAGENTA}🧠 Memory Usage Threshold Check${NC}${NOBLINK}"
echo "========================================"
MEMORY_TOTAL=$(free -m | grep Mem | awk '{print $2}')
MEMORY_USED=$(free -m | grep Mem | awk '{print $3}')
MEMORY_USAGE=$(awk "BEGIN { if (${MEMORY_TOTAL} > 0) printf \"%.1f\", (${MEMORY_USED}/${MEMORY_TOTAL})*100; else print 0 }")
echo -ne "Used Memory: ${RED}${MEMORY_USED}MB${NC} / ${CYAN}${MEMORY_TOTAL}MB${NC} = ${MAGENTA}${MEMORY_USAGE}% ${WHITE}"
awk -v val=${MEMORY_USAGE} 'BEGIN {for(i=0;i<val/10;i++) printf "▓"}'; echo -e "${NC}"
if (( $(echo "$MEMORY_USAGE > 85" | bc -l) )); then
    echo -e "${RED}[WARNING] Memory usage is above 85%!${NC}"
else
    echo -e "${GREEN}[INFO] Memory usage is within acceptable limits.${NC}"
fi
echo ""

# Step 5 - System Summary
sleep 4
echo -e "${BLINK}${GREEN}📊 System Summary${NC}${NOBLINK}"
echo "========================================"
TOTAL_PROCESSES=$(ps aux --no-heading | wc -l)
ZOMBIE_PROCESSES=$(ps aux | awk '{ if ($8 == "Z") print }' | wc -l)
START_TIME=$(who -b | awk '{print $3, $4}')
UPTIME=$(uptime -p)
CURRENT_USER=$(whoami)
LOGGED_IN_USERS=$(who | wc -l)

echo -e "🔢 Total Processes Running         : ${CYAN}${TOTAL_PROCESSES}${NC}"
echo -e "🧟 Zombie Processes                : ${RED}${ZOMBIE_PROCESSES}${NC}"
echo -e "🚀 System Started On              : ${MAGENTA}${START_TIME}${NC}"
echo -e "⏳ Uptime                         : ${GREEN}${UPTIME}${NC}"
echo -e "👤 Current User                   : ${YELLOW}${CURRENT_USER}${NC}"
echo -e "👥 Users Logged In Currently      : ${BLUE}${LOGGED_IN_USERS}${NC}"
echo ""

# Step 6 - Disk Usage
sleep 4
echo -e "${BLINK}${BLUE}💽 Disk Usage${NC}${NOBLINK}"
echo "========================================"
DISK_INFO=$(df -h / | tail -1)
DISK_SIZE=$(echo $DISK_INFO | awk '{print $2}')
DISK_USED=$(echo $DISK_INFO | awk '{print $3}')
DISK_AVAIL=$(echo $DISK_INFO | awk '{print $4}')
DISK_USAGE_PCT=$(echo $DISK_INFO | awk '{print $5}' | tr -d '%')

echo -e "Disk Size        : ${CYAN}${DISK_SIZE}${NC}"
echo -e "Used Space       : ${RED}${DISK_USED}${NC}"
echo -e "Available Space  : ${GREEN}${DISK_AVAIL}${NC}"
echo ""

# Step 7 - Disk Threshold
echo -e "${BLINK}${MAGENTA}💽 Disk Usage Threshold Check${NC}${NOBLINK}"
echo "========================================"
echo -ne "Disk Usage: ${MAGENTA}${DISK_USAGE_PCT}% ${WHITE}"
awk -v val=${DISK_USAGE_PCT} 'BEGIN {for(i=0;i<val/10;i++) printf "▓"}'; echo -e "${NC}"
if (( ${DISK_USAGE_PCT} > 85 )); then
    echo -e "${RED}[WARNING] Disk usage is above 85%!${NC}"
else
    echo -e "${GREEN}[INFO] Disk usage is within acceptable limits.${NC}"
fi
echo ""

# Step 8 - Top Processes
sleep 4
echo -e "${BLINK}${YELLOW}🔥 Top 5 Processes by CPU${NC}${NOBLINK}"
echo "========================================"
ps -eo user,pid,%cpu,%mem,cmd --sort=-%cpu | head -n 6
echo ""

echo -e "${BLINK}${CYAN}🧠 Top 5 Processes by Memory${NC}${NOBLINK}"
echo "========================================"
ps -eo user,pid,%cpu,%mem,cmd --sort=-%mem | head -n 6
echo ""

# Step 9 - Network Interfaces and Connectivity
sleep 4
echo -e "${BLINK}${MAGENTA}🌐 Network Interfaces & Internet Check${NC}${NOBLINK}"
echo "========================================"

# List all active network interfaces with their IPs
echo -e "${BLINK}${CYAN}🔌 Active Network Interfaces:${NC}${NOBLINK}"
ip -brief addr show up | grep -v "DOWN" | while read -r iface ip _; do
    if [[ $ip != "-" ]]; then
        echo -e "${GREEN}$iface${NC} → ${YELLOW}$ip${NC}"
    else
        echo -e "${RED}$iface${NC} → ${RED}[No IP Assigned]${NC}"
    fi
done
echo ""

# Interface speed (requires ethtool)
echo -e "${BLINK}${CYAN}⚡ Interface Speeds:${NC}${NOBLINK}"
for iface in $(ls /sys/class/net | grep -v lo); do
    SPEED="Unavailable"
    if command -v ethtool &> /dev/null; then
        SPEED_RAW=$(ethtool $iface 2>/dev/null | grep "Speed:")
        if [[ -n $SPEED_RAW ]]; then
            SPEED=$(echo $SPEED_RAW | awk '{print $2}')
        fi
    fi

    echo -ne "${YELLOW}$iface${NC} → ${MAGENTA}$SPEED${NC} "
    if [[ $SPEED == *"Mb/s"* ]]; then
        SPEED_NUM=$(echo $SPEED | grep -o '[0-9]*')
        BAR_LENGTH=$(( SPEED_NUM / 100 ))
        echo -ne "${WHITE}"
        for ((i = 0; i < BAR_LENGTH; i++)); do echo -n "▓"; done
    fi
    echo -e "${NC}"
done
echo ""

# Check Internet Connectivity
echo -e "${BLINK}${CYAN}🌍 Checking Internet Connectivity...${NC}${NOBLINK}"
if ping -q -c 1 -W 2 8.8.8.8 >/dev/null; then
    echo -e "${GREEN}${BLINK}[SUCCESS]${NOBLINK} Internet is reachable (8.8.8.8)${NC}"
else
    echo -e "${RED}${BLINK}[ERROR]${NOBLINK} No Internet connectivity detected!${NC}"
fi
echo ""

# Final Thank You
sleep 3
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}✅ Thank you for executing this script!${NC}"
sleep 0.5; echo -ne "${CYAN}🙏 "; sleep 0.4; echo -ne "${MAGENTA}${BLINK}Subscribe${NOBLINK}${NC}, "; sleep 0.5; echo -ne "${GREEN}${BLINK}Like${NOBLINK}${NC}, "; sleep 0.5; echo -ne "${BLUE}${BLINK}Share${NOBLINK}${NC}, "; sleep 0.5; echo -e "${YELLOW}${BLINK}and Comment!${NOBLINK}${NC}"
echo -e "${YELLOW}========================================${NC}"


