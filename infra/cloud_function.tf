resource "google_cloudfunctions2_function" "extractor" {
  name     = "pdf-text-extractor"
  location = "us-central1"

  build_config {
    runtime     = "python311"
    entry_point = "process_pdf"
    # use artifactregistry if building a container, but for source‐deploy:
    source {
      storage_source {
        # This points to a tarball or zip in GCS—Gen2 does not accept "source = 'functions'"
        # Instead, Terraform will package & upload automatically if you push with GitHub Actions.
        # For now, leave this empty or remove it; GitHub Actions will handle deployment.
      }
    }
  }

  service_config {
    service_account_email = google_service_account.func_sa.email
    timeout_seconds       = 300
    available_memory      = "512M"
    max_instance_count    = 5

    environment_variables = {
      TXT_BUCKET = google_storage_bucket.txt.name
    }
  }

    event_trigger {
    event_type   = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.pdf_raw.name
    }
  }
}