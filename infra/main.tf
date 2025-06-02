terraform {
  required_version = ">=1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-bucket-pdf2txt-demo"
    prefix = "pdf2txt"
  }
}