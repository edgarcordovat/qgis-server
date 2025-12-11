FROM debian:bookworm

# Evitar prompts
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas básicas
RUN apt-get update && apt-get install -y gnupg software-properties-common ca-certificates curl

# Añadir repositorio QGIS LTR
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45 && \
    echo "deb https://qgis.org/debian-ltr bookworm main" >> /etc/apt/sources.list && \
    apt-get update

# Instalar QGIS Server + FastCGI + NGINX
RUN apt-get install -y \
    qgis-server \
    python3-qgis \
    fcgiwrap \
    spawn-fcgi \
    nginx-light \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Crear carpetas necesarias
RUN mkdir -p /data

# Copiar tu proyecto QGIS
COPY project.qgz /data/project.qgz

# Copiar archivo de configuración del servidor QGIS (opcional)
COPY server.conf /etc/qgis/server.conf

# Reemplazar configuración por defecto de NGINX
RUN rm /etc/nginx/sites-enabled/default

# Crear configuración NGINX para QGIS Server
RUN printf "server {\n\
    listen 8080 default_server;\n\
    location / {\n\
        include /etc/nginx/fastcgi_params;\n\
        fastcgi_pass unix:/tmp/qgisserver.sock;\n\
        fastcgi_param SCRIPT_FILENAME /usr/lib/cgi-bin/qgis_mapserv.fcgi;\n\
        fastcgi_param QGIS_SERVER_LOG_STDERR 1;\n\
        fastcgi_param QGIS_SERVER_LOG_LEVEL 0;\n\
    }\n\
}\n" > /etc/nginx/sites-enabled/qgis.conf

# Exponer puerto
EXPOSE 8080

# Comando para iniciar QGIS Server + NGINX en Railway
CMD spawn-fcgi -s /tmp/qgisserver.sock -U www-data -G www-data /usr/lib/cgi-bin/qgis_mapserv.fcgi && \
    nginx -g 'daemon off;'
