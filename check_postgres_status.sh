#!/bin/bash
SERVER="192.168.0.102"
COMMUNITY="public"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================"
echo "   PostgreSQL Status Monitor"
echo "================================"
echo "Server: $SERVER"
echo "Time: $(date '+%H:%M:%S')"
echo "--------------------------------"

COUNT=$(snmpwalk -v 2c -c $COMMUNITY $SERVER .1.3.6.1.2.1.25.4.2.1.2 | grep -i postgres | wc -l)

echo -e "Process count: \033[1;36m$COUNT\033[0m"
echo ""

if [ $COUNT -eq 0 ]; then
    echo -e "${RED}❌ STATUS: STOPPED${NC}"
    echo -e "${RED}PostgreSQL is not running${NC}"
    exit 1
elif [ $COUNT -lt 5 ]; then
    echo -e "${YELLOW}⚠️ STATUS: WARNING${NC}"
    echo -e "${YELLOW}Running ($COUNT processes)${NC}"
    exit 0
else
    echo -e "${GREEN}✅ STATUS: RUNNING${NC}"
    echo -e "${GREEN}Running normally ($COUNT processes)${NC}"
    exit 0
fi
