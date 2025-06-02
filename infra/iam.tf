# Cloud Run SA → read txt bucket + sign URLs
resource "google_storage_bucket_iam_member" "run_view_txt" {
  bucket = google_storage_bucket.txt.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.run_sa.email}"
}

# Cloud Function SA → read raw, write txt
resource "google_storage_bucket_iam_member" "func_read_raw" {
  bucket = google_storage_bucket.pdf_raw.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.func_sa.email}"
}

resource "google_storage_bucket_iam_member" "func_write_txt" {
  bucket = google_storage_bucket.txt.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.func_sa.email}"
}