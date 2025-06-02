from fastapi import FastAPI, HTTPException, Query
from google.cloud import storage
import os, uuid, datetime, logging

PDF_BUCKET = os.getenv("PDF_BUCKET", "pdf-raw")
TXT_BUCKET = os.getenv("TXT_BUCKET", "txt")

app = FastAPI(title="PDF-to-Text API")
client = storage.Client()
log = logging.getLogger("uvicorn")

def _signed_url(blob: str, minutes: int = 15) -> str:
    return client.bucket(PDF_BUCKET).blob(blob).generate_signed_url(
        version="v4",
        expiration=datetime.timedelta(minutes=minutes),
        method="PUT",
        content_type="application/pdf",
    )

@app.get("/upload-url")
def upload_url(filename: str = Query(..., pattern=r".+\\.pdf$")):
    obj = f"{uuid.uuid4()}_{filename}"
    return {"uploadUrl": _signed_url(obj), "fileId": obj}

@app.get("/status/{file_id}")
def status(file_id: str):
    ok = client.bucket(TXT_BUCKET).blob(f"{file_id}.txt").exists()
    return {"status": "done" if ok else "processing"}

@app.get("/text/{file_id}")
def text(file_id: str):
    blob = client.bucket(TXT_BUCKET).blob(f"{file_id}.txt")
    if not blob.exists():
        raise HTTPException(404, "Text not ready")
    return {"text": blob.download_as_text()}
