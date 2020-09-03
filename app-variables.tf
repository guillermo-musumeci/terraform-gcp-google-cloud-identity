#############################
## Application - Variables ##
#############################

# app name 
variable "app_name" {
  type        = string
  description = "This variable defines the application name used to build resources"
}

# company name 
variable "company" {
  type        = string
  description = "This variable defines the company name used to build resources"
}

# company prefix 
variable "prefix" {
  type        = string
  description = "This variable defines the company name prefix used to build resources"
}

# GCP region
variable "region" {
  type        = string
  description = "GCP region where the resource group will be created"
}

# application environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
}