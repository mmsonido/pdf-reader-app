resource "google_cloudfunctions2_function" "extractor" {
  name     = "pdf-text-extractor"
  location = "us"               # <-- Debe ser "us", igual que tu bucket pdf_raw
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "process_pdf"

    source {
      storage_source {
        bucket     = "pdf2txt-demo-functions"
        object     = "pdf_extractor_source.zip"
        generation = 1
      }
    }

    # Originalmente tenías: google_service_account.func_sa.email
    # Aquí debes usar el formato completo:
    service_account = "projects/${var.project_id}/serviceAccounts/${google_service_account.func_sa.email}"
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    # No hace falta especificar trigger_region: heredará la misma ubicación (us)
    event_filters {
      attribute = "bucket"
      value     = "pdf2txt-demo-pdf-raw"
    }
    retry_policy = "RETRY_POLICY_RETRY"
  }

  service_config {
    environment_variables = {
      TXT_BUCKET = "pdf2txt-demo-txt"
    }
    available_memory   = "512M"
    max_instance_count = 5
    timeout_seconds    = 300
    ingress_settings   = "ALLOW_ALL"
  }
}