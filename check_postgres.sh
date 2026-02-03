#!/bin/bash
SERVER="192.168.0.102"
COMMUNITY="public"

echo "======================================"
echo "   МОНИТОРИНГ POSTGRESQL"
echo "======================================"
echo "Сервер: $SERVER"
echo "Время: $(date '+%d.%m.%Y %H:%M:%S')"
echo "--------------------------------------"

# Получаем процессы
PROCESSES=$(snmpwalk -v 2c -c $COMMUNITY $SERVER .1.3.6.1.2.1.25.4.2.1.2 | grep -i postgres)
COUNT=$(echo "$PROCESSES" | wc -l)

echo "Найдено процессов: $COUNT"
echo ""
echo "Список процессов:"
echo "-----------------"
echo "$PROCESSES" | head -10
echo "--------------------------------------"
