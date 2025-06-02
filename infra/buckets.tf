resource "google_storage_bucket" "pdf_raw" {
  name     = "pdf2txt-demo-pdf-raw"
  location = "US-CENTRAL1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "txt" {
  name                        = "${var.project_id}-txt"
  location                    = "US"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle_rule {
    condition { age = 30 }
    action    { type = "Delete" }
  }
}

resource "google_storage_bucket" "frontend" {
  name                        = "${var.project_id}-frontend"
  location                    = "US"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_binding" "frontend_public" {
  bucket  = google_storage_bucket.frontend.name
  role    = "roles/storage.objectViewer"
  members = ["allUsers"]
}