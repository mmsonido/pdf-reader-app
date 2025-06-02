# Dockerfile

# 1. Partimos de una imagen oficial de Python 3.11 slim
FROM python:3.11-slim

# 2. Establecemos carpeta de trabajo
WORKDIR /app

# 3. Copiamos las dependencias y las instalamos
COPY functions/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copiamos el archivo main.py a /app
COPY functions/main.py ./

# 5. Exponemos el puerto 8080 (por convención en Cloud Run)
EXPOSE 8080

# 6. Indicamos a Gunicorn que arranque la app en production
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]