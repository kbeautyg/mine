# Используем образ с Java 17 (необходима для Minecraft 1.20.1 Fabric)
FROM eclipse-temurin:17-jre-alpine

# Устанавливаем рабочую директорию
WORKDIR /minecraft

# Устанавливаем bash для скриптов
RUN apk add --no-cache bash

# Копируем все файлы сервера
COPY . /minecraft/

# Устанавливаем права на выполнение
RUN chmod +x /minecraft/start.sh

# Создаем директории если не существуют
RUN mkdir -p /minecraft/world /minecraft/logs

# Открываем порт для сервера
EXPOSE 25565

# Запускаем сервер
CMD ["/minecraft/start.sh"]

