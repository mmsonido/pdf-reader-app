FROM python:3.11-slim

WORKDIR /app

# dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copia del código
COPY functions/ ./functions/

# Cloud Run inyecta $PORT en tiempo de ejecución
ENV PORT=8080

# ejecutamos el módulo functions.main
CMD ["python", "-m", "functions.main"]