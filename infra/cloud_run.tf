resource "google_cloud_run_service" "api" {
  name     = "pdf-api"
  location = "us-central1"

  template {
    metadata {
      # Opcional: si quieres etiquetar el servicio, lo puedes añadir aquí.
      # labels = {
      #   "env" = "prod"
      # }
    }

    spec {
      # Apunta al service account que creaste para Cloud Run
      service_account_name = google_service_account.run_sa.email

      containers {
        # Imagen recién subida a Artifact Registry
        image = "us-central1-docker.pkg.dev/${var.project_id}/backend-repo/pdf-api:latest"

        # Variable de entorno para el bucket de PDFs
        env {
          name  = "PDF_BUCKET"
          value = google_storage_bucket.pdf_raw.name
        }

        # Variable de entorno para el bucket de texto resultante
        env {
          name  = "TXT_BUCKET"
          value = google_storage_bucket.txt.name
        }
      }

      # Asegura que solo procese una petición a la vez
      container_concurrency = 1
    }

    metadata {
      annotations = {
        # Máximo 2 instancias en escalado automático
        "autoscaling.knative.dev/maxScale" = "2"
      }
    }
  }

  # Tráfico: 100% a la última revisión
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