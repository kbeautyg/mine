# Используем базовый образ с Java 8 (необходима для Minecraft 1.12.2)
FROM openjdk:8-jre-alpine

# Устанавливаем рабочую директорию
WORKDIR /minecraft

# Устанавливаем переменные окружения
ENV MINECRAFT_VERSION=1.12.2
ENV FORGE_VERSION=14.23.5.2860
ENV SERVER_JAR=forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar
ENV MEMORY=2G

# Устанавливаем wget для загрузки файлов
RUN apk add --no-cache wget bash

# Создаем директории
RUN mkdir -p /minecraft/mods /minecraft/config /minecraft/world

# Копируем файлы конфигурации
COPY server.properties /minecraft/
COPY eula.txt /minecraft/
COPY start.sh /minecraft/

# Делаем скрипт запуска исполняемым
RUN chmod +x /minecraft/start.sh

# Открываем порт для сервера
EXPOSE 25565

# Запускаем сервер
CMD ["/minecraft/start.sh"]



