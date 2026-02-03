#!/bin/bash
echo "=== СОЗДАНИЕ ПРОСТОГО ГРАФИКА ==="

# 1. Создаем данные вручную
echo "Создаем тестовые данные..."
cat > cpu_data.txt << DATA
$(date -d '-12 min' '+%H:%M') 8
$(date -d '-11 min' '+%H:%M') 12
$(date -d '-10 min' '+%H:%M') 15
$(date -d '-9 min'  '+%H:%M') 10
$(date -d '-8 min'  '+%H:%M') 18
$(date -d '-7 min'  '+%H:%M') 9
$(date -d '-6 min'  '+%H:%M') 14
$(date -d '-5 min'  '+%H:%M') 11
$(date -d '-4 min'  '+%H:%M') 16
$(date -d '-3 min'  '+%H:%M') 7
$(date -d '-2 min'  '+%H:%M') 13
$(date -d '-1 min'  '+%H:%M') 9
$(date '+%H:%M') 10
DATA

# 2. Создаем простой график через gnuplot
cat > graph_script.gnu << GNUPLOT
set terminal png size 900,500
set output 'SIMPLE_GRAPH.png'
set title 'Мониторинг CPU через SNMP'
set xlabel 'Время'
set ylabel 'Загрузка CPU (%)'
set grid
set style data linespoints
plot 'cpu_data.txt' using 2 with lines lw 3 lc rgb '#4A90E2' title 'Загрузка CPU'
GNUPLOT

# 3. Запускаем gnuplot если есть
if command -v gnuplot &> /dev/null; then
    gnuplot graph_script.gnu
    echo "График создан: SIMPLE_GRAPH.png"
    ls -lh SIMPLE_GRAPH.png
else
    # Если нет gnuplot, создаем текстовый график
    echo "=== ТЕКСТОВЫЙ ГРАФИК ==="
    echo "Время     | Загрузка CPU"
    echo "----------|--------------"
    cat cpu_data.txt | while read time value; do
        bars=$((value / 2))
        printf "%8s | " "$time"
        for ((i=0; i<bars; i++)); do printf "█"; done
        printf " %2d%%\n" "$value"
    done
    echo "Создайте график на компьютере с gnuplot"
fi
