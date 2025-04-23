#!/bin/bash

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Header
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}🌐 Welcome to Cloud Gen Softech${NC}"
echo -e "${CYAN}📅 Date: $(date '+%Y-%m-%d') 🕒 Time: $(date '+%H:%M:%S')${NC}"
echo -e "${MAGENTA}👨‍💻 Author: Ravindra Thota${NC}"
echo -e "${YELLOW}Compatible with Linux-based systems (Ubuntu, CentOS, Debian, etc.)${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# System Summary
echo -e "${CYAN}📊 System Summary${NC}"
echo "========================================"

TOTAL_PROCESSES=$(ps -e --no-headers | wc -l)
ZOMBIE_PROCESSES=$(ps aux | awk '{ if ($8 == "Z") print $0; }' | wc -l)
UPTIME_INFO=$(uptime -p)
BOOT_TIME=$(who -b | awk '{print $3, $4}')
DAYS_UP=$(awk '{print int($1/86400)" days, "int(($1%86400)/3600)" hrs, "int(($1%3600)/60)" mins"}' /proc/uptime)
CURRENT_USER=$(whoami)
LOGGED_IN_USERS=$(who | wc -l)

echo -e "🧠 System has Memory, Process, and Disk Monitoring"
echo -e "🔢 Total Processes Running         : ${YELLOW}${TOTAL_PROCESSES}${NC}"
echo -e "🧟 Zombie Processes                : ${RED}${ZOMBIE_PROCESSES}${NC}"
echo -e "🚀 System Started On              : ${YELLOW}${BOOT_TIME}${NC}"
echo -e "⏳ Uptime                         : ${GREEN}${DAYS_UP}${NC}"
echo -e "👤 Current User                   : ${CYAN}${CURRENT_USER}${NC}"
echo -e "👥 Users Logged In Currently      : ${YELLOW}${LOGGED_IN_USERS}${NC}"
echo ""

# CPU Usage
echo -e "${CYAN}🖥️  CPU Usage${NC}"
echo "========================================"
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo -e "Usage       : ${GREEN}${CPU}%${NC}"
echo ""

# Memory Usage
echo -e "${MAGENTA}🧠 Memory Usage${NC}"
echo "========================================"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $7}')
MEM_USED_PCT=$(awk "BEGIN {printf \"%.1f\", (${MEM_USED}/${MEM_TOTAL})*100}")
MEM_FREE_PCT=$(awk "BEGIN {printf \"%.1f\", (${MEM_FREE}/${MEM_TOTAL})*100}")

echo -e "Total Memory     : ${YELLOW}${MEM_TOTAL}${NC} MB"
echo -e "Used Memory      : ${YELLOW}${MEM_USED}${NC} MB (${MEM_USED_PCT}%)"
echo -e "Free/Available   : ${YELLOW}${MEM_FREE}${NC} MB (${MEM_FREE_PCT}%)"
echo ""

# Disk Usage
echo -e "${CYAN}💽 Disk Usage${NC}"
echo "========================================"
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')

echo -e "Disk Size        : ${YELLOW}${DISK_TOTAL}${NC}"
echo -e "Used Space       : ${YELLOW}${DISK_USED}${NC}"
echo -e "Available Space  : ${YELLOW}${DISK_AVAIL}${NC}"
echo ""

# Top 5 Processes by CPU
echo -e "${RED}🔥 Top 5 Processes by CPU${NC}"
echo "========================================"
ps -eo user,pid,%cpu,%mem,command --sort=-%cpu | head -n 6
echo ""

# Top 5 Processes by Memory
echo -e "${MAGENTA}🧠 Top 5 Processes by Memory${NC}"
echo "========================================"
ps -eo user,pid,%cpu,%mem,command --sort=-%mem | head -n 6
echo ""

# Footer
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}✅ Thank you for executing this script!${NC}"
echo -e "${CYAN}🙏 Don't forget to Subscribe, Like, Share, and Comment!${NC}"
echo -e "${YELLOW}========================================${NC}"
