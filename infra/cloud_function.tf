resource "google_cloudfunctions2_function" "extractor" {
  name     = "pdf-text-extractor"
  location = "us-central1"
  runtime  = "python311"

  build_config {
    runtime      = "python311"
    entry_point  = "process_pdf"
    source       = "functions"          # local dir
  }

  service_config {
    service_account_email = google_service_account.func_sa.email
    timeout_seconds       = 300
    available_memory      = "512M"
    max_instance_count    = 5
    environment_variables = { TXT_BUCKET = google_storage_bucket.txt.name }
  }

  event_trigger {
    event_type   = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY"
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.pdf_raw.name
    }
  }
}