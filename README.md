# pdf-reader-app

A serverless PDF-to-TXT pipeline on Google Cloud Platform (GCP).

## Overview
This project provides a secure, scalable, and automated way to extract text from PDF files using a modern web interface and cloud-native backend. Users upload PDFs via a React frontend; files are processed by a FastAPI backend and a Python Cloud Function, with all data stored securely in Google Cloud Storage (GCS). Infrastructure is managed with Terraform, and CI/CD is automated with GitHub Actions.

## Architecture
```
[User]
  |
  v
[React Frontend (Vite)]
  |
  v
[FastAPI Backend (Cloud Run)]
  |
  v
[GCS Bucket: Raw PDFs] --(event)--> [Cloud Function: PDF→TXT] --(output)--> [GCS Bucket: TXT]
  |
  v
[Frontend fetches TXT via signed URL]
```

## Features
- Modern React frontend for PDF upload and status
- FastAPI backend for API, signed URLs, and orchestration
- Python Cloud Function (pdfplumber) to extract text from PDFs
- Secure, private GCS buckets with short-lived signed URLs
- Terraform IaC for all GCP resources
- GitHub Actions for CI/CD
- Least-privilege IAM and lifecycle management

## Tech Stack
- **Frontend:** React, Vite, JavaScript
- **Backend:** FastAPI, Uvicorn, Python
- **Cloud Function:** Python, pdfplumber
- **Cloud:** Google Cloud Run, Google Cloud Functions, Google Cloud Storage
- **IaC:** Terraform
- **CI/CD:** GitHub Actions

## Directory Structure
```
frontend/   # React app (Vite)
backend/    # FastAPI app (Cloud Run)
functions/  # Python Cloud Function (PDF→TXT)
infra/      # Terraform IaC for GCP resources
.github/    # GitHub Actions workflows
```

## Setup & Deployment
1. **Clone the repository**
2. **Frontend:**
   - `cd frontend`
   - `npm install`
   - `npm run dev` (for local development)
3. **Backend:**
   - `cd backend`
   - `pip install -r requirements.txt`
   - `uvicorn app.main:app --reload` (for local development)
4. **Cloud Function:**
   - `cd functions`
   - `pip install -r requirements.txt`
   - Deploy using Terraform or gcloud
5. **Infrastructure:**
   - `cd infra`
   - Configure your GCP project and credentials
   - `terraform init && terraform apply`
6. **CI/CD:**
   - GitHub Actions will build, test, and deploy on push

## Usage
- Visit the frontend URL
- Upload a PDF file
- Wait for processing (status shown)
- Download or view the extracted TXT file

## Security & IAM
- All buckets are private by default
- Backend issues short-lived signed URLs for secure access
- IAM roles are least-privilege, managed via Terraform
- Service accounts are separated for Cloud Run and Cloud Function
