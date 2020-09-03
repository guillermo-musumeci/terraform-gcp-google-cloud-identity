#######################################
## Google Cloud Identity - Variables ##
#######################################

# define GCP project id to store the service account
variable "project_id" {
  type        = string
  description = "GCP project name"
}

variable "customer_id" {
  type        = string
  description = "Google Customer ID"
}

variable "company_domain" {
  type        = string
  description = "Company email domain"
}

variable "owners_members" {
  type        = list(string)
  description = "List of users to add to the owners group"
}

variable "editors_members" {
  type        = list(string)
  description = "List of users to add to the editors group"
}

variable "viewers_members" {
  type        = list(string)
  description = "List of users to add to the viewers group"
}