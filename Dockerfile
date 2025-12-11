FROM qgis/qgis-server:ltr

# Proyecto QGIS
RUN mkdir -p /io/data/mi_proyecto
COPY mi_proyecto.qgs /io/data/mi_proyecto/mi_proyecto.qgs
COPY mis_datos.gpkg /io/data/mi_proyecto/mis_datos.gpkg

# Frontend (HTML con Leaflet) -> raíz del sitio
COPY web/index.html /usr/share/nginx/html/index.html

EXPOSE 80

