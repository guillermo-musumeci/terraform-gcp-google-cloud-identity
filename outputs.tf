####################################
## Google Cloud Identity - Output ##
####################################

output "project_id" {
  value = var.project_id
}

output "service-account" {
  value = local.sa_name
}

output "group_name_owners" {
  value = local.owners_group_name
}

output "group_name_editors" {
  value = local.editors_group_name
}

output "group_name_viewers" {
  value = local.viewers_group_name 
}

