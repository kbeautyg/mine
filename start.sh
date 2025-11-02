#!/bin/bash

# Скрипт запуска Minecraft Fabric сервера - Arcania 1.3.3

echo "=========================================="
echo "Minecraft 1.20.1 Fabric Server - Arcania 1.3.3"
echo "=========================================="

# Установка переменных
MEMORY="${MEMORY:-8G}"
PORT="${PORT:-25565}"

# Обновляем порт в server.properties если указан PORT
if [ ! -z "$PORT" ]; then
    sed -i "s/server-port=.*/server-port=$PORT/" server.properties
fi

# Информация о запуске
echo "=========================================="
echo "Запуск сервера на порту $PORT"
echo "Выделено памяти: $MEMORY"
echo "Модов загружено: $(ls -1 mods/*.jar 2>/dev/null | wc -l)"
echo "=========================================="

# Проверяем наличие server.jar
if [ ! -f "server.jar" ]; then
    echo "ОШИБКА: server.jar не найден!"
    exit 1
fi

# Запускаем сервер с оптимизированными параметрами JVM для Fabric
exec java -Xms${MEMORY} -Xmx${MEMORY} \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar server.jar nogui

