FROM qgis/qgis-server:ltr

# Carpeta del proyecto dentro del contenedor
RUN mkdir -p /io/data/mi_proyecto

# Copiamos proyecto y datos JUNTOS (misma carpeta)
COPY mi_proyecto.qgs /io/data/mi_proyecto/mi_proyecto.qgs
COPY mis_datos.gpkg /io/data/mi_proyecto/mis_datos.gpkg

EXPOSE 80
