from fastapi import FastAPI, HTTPException, Query
import uuid, datetime, os

# If LOCAL_DEV is set, we skip any GCS calls
LOCAL_DEV = os.getenv("LOCAL_DEV", "1") == "1"

app = FastAPI(title="PDF-to-Text API (local mode)")

def _dummy_signed_url(blob: str, minutes: int = 15) -> str:
    expires = (datetime.datetime.utcnow() + datetime.timedelta(minutes=minutes)).isoformat()
    return f"https://example.com/upload/{blob}?expires={expires}"

@app.get("/upload-url")
def upload_url(filename: str = Query(..., pattern=r".+\.pdf$")):
    blob_name = f"{uuid.uuid4()}_{filename}"
    if LOCAL_DEV:
        # Return a fake URL and fileId
        return {"uploadUrl": _dummy_signed_url(blob_name), "fileId": blob_name}
    # In non-local mode, you’d generate a real signed URL via GCS
    raise HTTPException(500, "Cannot generate signed URL outside local mode")

@app.get("/status/{file_id}")
def status(file_id: str):
    if LOCAL_DEV:
        # Always “done” after a few seconds; here we just return done immediately
        return {"status": "done"}
    # Otherwise you’d check GCS for a real .txt file
    raise HTTPException(500, "Cannot check status outside local mode")

@app.get("/text/{file_id}")
def text(file_id: str):
    if LOCAL_DEV:
        # Return dummy text
        sample = f"(Dummy text content for {file_id})\nLine 2 of sample..."
        return {"text": sample}
    # Otherwise you’d download real text from GCS
    raise HTTPException(500, "Cannot fetch text outside local mode")