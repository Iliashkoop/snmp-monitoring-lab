#!/bin/bash
SERVER="192.168.0.102"
COMMUNITY="public"

echo "========================================="
echo "   ADVANCED SYSTEM MONITORING"
echo "========================================="
echo "Server: $SERVER"
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "-----------------------------------------"

echo ""
echo "[1] CPU LOAD:"
cpu=$(snmpget -v 2c -c $COMMUNITY $SERVER .1.3.6.1.4.1.2021.10.1.3.1 -Oqv 2>/dev/null)
echo "   • 1 minute: ${cpu}%"

echo ""
echo "[2] MEMORY:"
mem=$(snmpget -v 2c -c $COMMUNITY $SERVER .1.3.6.1.4.1.2021.4.6.0 -Oqv 2>/dev/null)
[ -n "$mem" ] && echo "   • Free: $((mem / 1024)) MB" || echo "   • Free: Error"

echo ""
echo "[3] DISK:"
disk=$(snmpget -v 2c -c $COMMUNITY $SERVER .1.3.6.1.4.1.2021.9.1.7.1 -Oqv 2>/dev/null)
[ -n "$disk" ] && echo "   • Free (/): $((disk / 1024 / 1024)) GB" || echo "   • Free: Error"

echo ""
echo "[4] PROCESSES:"
total=$(snmpget -v 2c -c $COMMUNITY $SERVER .1.3.6.1.2.1.25.1.6.0 -Oqv 2>/dev/null)
echo "   • Total: ${total}"
pg_count=$(snmpwalk -v 2c -c $COMMUNITY $SERVER .1.3.6.1.2.1.25.4.2.1.2 | grep -i postgres | wc -l)
echo "   • PostgreSQL: ${pg_count}"

echo ""
echo "[5] UPTIME:"
uptime=$(snmpget -v 2c -c $COMMUNITY $SERVER .1.3.6.1.2.1.1.3.0 -Oqv 2>/dev/null)
if [ -n "$uptime" ]; then
    # Убираем кавычки и преобразуем
    uptime_clean=$(echo "$uptime" | tr -d '"')
    echo "   • System: ${uptime_clean}"
else
    echo "   • Uptime: Error"
fi

echo ""
echo "[6] POSTGRESQL METRICS:"
echo "   • Active connections:"
extend_output=$(snmpwalk -v 2c -c $COMMUNITY $SERVER .1.3.6.1.4.1.8072.1.3.2 2>/dev/null)
conn=$(echo "$extend_output" | grep pg_connections | awk -F '"' '{print $2}' 2>/dev/null)
echo "     ${conn:-No data}"

echo "   • Test calculation (2^10):"
pow=$(echo "$extend_output" | grep pg_pow | awk -F '"' '{print $2}' 2>/dev/null)
echo "     ${pow:-No data}"

echo "   • Echo test:"
echo_test=$(echo "$extend_output" | grep echo_test | awk -F '"' '{print $2}' 2>/dev/null)
echo "     ${echo_test:-No data}"

echo "-----------------------------------------"
echo "Monitoring complete!"
