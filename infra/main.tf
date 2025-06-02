terraform {
  required_version = ">=1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-bucket"
    prefix = "pdf2txt"
  }
}