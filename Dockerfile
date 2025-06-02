# FROM base
FROM python:3.11-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Ya que estamos en functions/, aquí basta con copiar requirements.txt directamente:
COPY requirements.txt ./

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copia TODO el resto del código de funciones
COPY . .

# Expone el puerto que usa Flask (8080) y define el entrypoint
ENV PORT=8080
CMD ["python", "main.py"]