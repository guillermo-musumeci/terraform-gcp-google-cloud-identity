#####################
## Provider - Main ##
#####################

terraform {
  required_version = ">= 0.13"
  # backend "gcs" {
  #   credentials = "account.json"
  #   bucket  = "kopicloud-gcp-tfstate"
  #   prefix  = "core/core-state"
  # }
}

provider "google" {
  project     = var.gcp_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region
}

provider "google-beta" {
  project     = var.gcp_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region
}
