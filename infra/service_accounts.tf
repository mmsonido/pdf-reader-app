resource "google_service_account" "run_sa"  { account_id = "pdf-api-sa" }
resource "google_service_account" "func_sa" { account_id = "pdf-extractor-sa" }

resource "google_project_iam_member" "run_signer" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.run_sa.email}"
  role    = "roles/iam.serviceAccountTokenCreator"
}