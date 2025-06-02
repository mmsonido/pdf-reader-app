FROM python:3.11-slim
WORKDIR /app

# dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# código
COPY . .

# --- ARRANQUE ---
# ⬅️  si usas main.py en la raíz
CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]