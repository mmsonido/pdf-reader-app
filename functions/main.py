import os
import pdfplumber
import tempfile
from google.cloud import storage

storage_client = storage.Client()
TXT_BUCKET = os.getenv("TXT_BUCKET", "txt")

def process_pdf(event, context):
    """
    Triggered by a Cloud Storage "finalize" event.
    Downloads the new PDF, extracts text with pdfplumber,
    and uploads a .txt file into the TXT_BUCKET.
    """
    bucket_name = event["bucket"]
    pdf_name    = event["name"]

    # Download the PDF to a temporary file
    tmp_file = tempfile.NamedTemporaryFile(delete=False)
    storage_client.bucket(bucket_name).blob(pdf_name).download_to_filename(tmp_file.name)

    # Extract text from every page
    text_content = ""
    with pdfplumber.open(tmp_file.name) as pdf:
        for page in pdf.pages:
            page_text = page.extract_text() or ""
            text_content += page_text + "\n"

    # Upload the text file (same base name + ".txt")
    text_blob = storage_client.bucket(TXT_BUCKET).blob(f"{pdf_name}.txt")
    text_blob.upload_from_string(text_content, content_type="text/plain")
    print(f"Extracted text for {pdf_name} → {TXT_BUCKET}/{pdf_name}.txt")

from functions_framework import create_app
app = create_app(target="process_pdf")