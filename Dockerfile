# ---- Dockerfile (root of repo) ----
    FROM python:3.11-slim
    WORKDIR /app
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    COPY . .
    
    # IMPORTANT: point to the real file
    CMD ["python", "functions/main.py"]