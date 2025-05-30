#!/bin/bash

# Limpiar recursos existentes
docker stop samplerunning 2>/dev/null || true
docker rm samplerunning 2>/dev/null || true
rm -rf tempdir 2>/dev/null || true

# Crear estructura
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# Copiar archivos
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Crear Dockerfile
cat > tempdir/Dockerfile << EOF
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
EOF

# Construir y ejecutar
cd tempdir
docker build -t sampleapp .
docker run --rm -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a