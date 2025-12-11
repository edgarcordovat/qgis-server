FROM qgis/qgis-server:ltr

# Crea el directorio donde estará tu proyecto
RUN mkdir -p /io/data

# Copia tu proyecto QGIS al directorio que espera la imagen
COPY mi_proyecto.qgs /io/data/

# Expone el puerto 80
EXPOSE 80

# Start server: la imagen ya trae ENTRYPOINT configurado
CMD ["/usr/local/bin/start-xvfb-nginx.sh"]
