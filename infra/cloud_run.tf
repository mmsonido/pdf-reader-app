resource "google_cloud_run_service" "api" {
  name     = "pdf-api"
  location = "us-central1"

  template {
    # Único bloque "metadata" para las anotaciones de Knative/autoscaling
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "2"
      }
    }

    spec {
      service_account_name = google_service_account.run_sa.email

      containers {
        image = "us-central1-docker.pkg.dev/${var.project_id}/backend-repo/pdf-api:latest"

        env {
          name  = "PDF_BUCKET"
          value = google_storage_bucket.pdf_raw.name
        }

        env {
          name  = "TXT_BUCKET"
          value = google_storage_bucket.txt.name
        }
      }

      container_concurrency = 1
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_invoke" {
  location = google_cloud_run_service.api.location
  service  = google_cloud_run_service.api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}