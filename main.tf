##################################
## Google Cloud Identity - Main ##
##################################

# Create a local variables
locals {
  sa_name            = "sa-${var.prefix}-${var.app_name}-${var.environment}"
  owners_group_name  = lower("${var.prefix}-${var.app_name}-${var.environment}-owners")
  editors_group_name = lower("${var.prefix}-${var.app_name}-${var.environment}-editors")
  viewers_group_name = lower("${var.prefix}-${var.app_name}-${var.environment}-viewers")
}

# Create a GCP Service Account
resource "google_service_account" "service-account" {
  account_id   = local.sa_name
  display_name = local.sa_name
  description  = "Terraform Service Account for ${var.app_name}"
  project      = var.project_id
}

# Create a GCP IAM Policy for Service Account
data "google_iam_policy" "service-account-iam-policy" {
  binding {
    role = "roles/owner"
    members = [
      "serviceAccount:${google_service_account.service-account.email}",
    ]
  }
}

# Assign IAM roles to the Service Account
resource "google_service_account_iam_policy" "service-account-iam" {
  service_account_id = google_service_account.service-account.id
  policy_data        = data.google_iam_policy.service-account-iam-policy.policy_data
}

# Generate the Service Account Key
resource "google_service_account_key" "service-account-key" {
  depends_on = [google_service_account.service-account]

  service_account_id = google_service_account.service-account.id
}

# Save Service Account to JSON (DEBUG)
resource "local_file" "service-account-key-json" {
  content  = base64decode(google_service_account_key.service-account-key.private_key)
  filename = "${path.module}/${local.sa_name}.json"
}

# Create Owners Group
resource "google_cloud_identity_group" "owners-group" {
  provider = google-beta
  display_name = local.owners_group_name
  parent = "customers/${var.customer_id}"

  group_key {
    id = "${local.owners_group_name}@${var.company_domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

# Create Editors Group
resource "google_cloud_identity_group" "editors-group" {
  provider = google-beta
  display_name = local.editors_group_name
  parent = "customers/${var.customer_id}"

  group_key {
    id = "${local.editors_group_name}@${var.company_domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

# Create Viewers Group
resource "google_cloud_identity_group" "viewers-group" {
  provider = google-beta
  display_name = local.viewers_group_name
  parent = "customers/${var.customer_id}"

  group_key {
    id = "${local.viewers_group_name}@${var.company_domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

# Assign Groups to the Project
resource "google_project_iam_policy" "group-iam-policy" {
  depends_on = [
    google_cloud_identity_group.owners-group,
    google_cloud_identity_group.editors-group,
    google_cloud_identity_group.viewers-group
  ]

  project     = var.project_id
  policy_data = data.google_iam_policy.groups-iam-policy.policy_data
}

# Groups Policy
data "google_iam_policy" "groups-iam-policy" {
  binding {
    role = "roles/owner"

    members = [
      "group:${local.owners_group_name}@${var.company_domain}",
    ]
  }

  binding {
    role = "roles/editor"

    members = [
      "group:${local.editors_group_name}@${var.company_domain}",
    ]
  }

  binding {
    role = "roles/reader"

    members = [
      "group:${local.viewers_group_name}@${var.company_domain}",
    ]
  }
}

# Add members to the Owners Group
resource "google_cloud_identity_group_membership" "owners-group-membership" {
  provider = google-beta
  group    = google_cloud_identity_group.owners-group.id

 for_each = toset(var.owners_members)

  member_key {
    id = each.value
  }

  roles {
    name = "MEMBER"
  }

  roles {
    name = "MANAGER"
  }
}

# Add members to the Editors Group
resource "google_cloud_identity_group_membership" "editors-group-membership" {
  provider = google-beta
  group    = google_cloud_identity_group.editors-group.id

  for_each = toset(var.editors_members)

  member_key {
    id = each.value
  }

  roles {
    name = "MEMBER"
  }

  roles {
    name = "MANAGER"
  }
}

# Add members to the Viewers Group
resource "google_cloud_identity_group_membership" "viewers-group-membership" {
  provider = google-beta
  group    = google_cloud_identity_group.viewers-group.id

  for_each = toset(var.viewers_members)

  member_key {
    id = each.value
  }

  roles {
    name = "MEMBER"
  }

  roles {
    name = "MANAGER"
  }
}

