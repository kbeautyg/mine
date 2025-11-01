#!/bin/bash

# Скрипт запуска Minecraft Forge сервера 1.12.2

echo "=========================================="
echo "Minecraft 1.12.2 Forge Server Launcher"
echo "=========================================="

# Установка переменных
FORGE_VERSION="${FORGE_VERSION:-14.23.5.2860}"
MINECRAFT_VERSION="${MINECRAFT_VERSION:-1.12.2}"
FORGE_INSTALLER="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar"
FORGE_UNIVERSAL="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-universal.jar"
MEMORY="${MEMORY:-2G}"
PORT="${PORT:-25565}"

# Проверяем, установлен ли Forge
if [ ! -f "$FORGE_UNIVERSAL" ]; then
    echo "Forge не найден, загружаем..."
    
    # Загружаем Forge installer
    if [ ! -f "$FORGE_INSTALLER" ]; then
        echo "Загрузка Forge installer..."
        wget -q "https://maven.minecraftforge.net/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar" -O "$FORGE_INSTALLER"
        
        if [ $? -ne 0 ]; then
            echo "Ошибка загрузки Forge installer!"
            exit 1
        fi
    fi
    
    # Устанавливаем Forge
    echo "Установка Forge сервера..."
    java -jar "$FORGE_INSTALLER" --installServer
    
    if [ $? -ne 0 ]; then
        echo "Ошибка установки Forge!"
        exit 1
    fi
    
    echo "Forge успешно установлен!"
fi

# Обновляем порт в server.properties если указан PORT
if [ ! -z "$PORT" ]; then
    sed -i "s/server-port=.*/server-port=$PORT/" server.properties
fi

# Запускаем сервер
echo "=========================================="
echo "Запуск сервера на порту $PORT"
echo "Выделено памяти: $MEMORY"
echo "=========================================="

# Ищем правильный JAR файл для запуска
if [ -f "$FORGE_UNIVERSAL" ]; then
    SERVER_JAR="$FORGE_UNIVERSAL"
elif [ -f "forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar" ]; then
    SERVER_JAR="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar"
else
    echo "Не найден файл сервера!"
    ls -la
    exit 1
fi

exec java -Xms${MEMORY} -Xmx${MEMORY} \
    -XX:+UseG1GC \
    -XX:+UnlockExperimentalVMOptions \
    -XX:MaxGCPauseMillis=100 \
    -XX:+DisableExplicitGC \
    -XX:TargetSurvivorRatio=90 \
    -XX:G1NewSizePercent=50 \
    -XX:G1MaxNewSizePercent=80 \
    -XX:InitiatingHeapOccupancyPercent=10 \
    -XX:G1MixedGCLiveThresholdPercent=50 \
    -Dfml.queryResult=confirm \
    -jar "$SERVER_JAR" nogui



