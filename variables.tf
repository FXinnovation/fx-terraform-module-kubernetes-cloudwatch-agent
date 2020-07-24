#####
# Global
#####

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "namespace" {
  description = "Namespace in which the module will be deployed."
  default     = "kube-system"
}

variable "labels" {
  description = "Map of labels that will be applied on all kubernetes resources."
  default     = {}
}

variable "annotations" {
  description = "Map of annotations that will be applied on all kubernetes resources."
  default     = {}
}

#####
# Application
#####

variable "cluster_name" {
  description = "Name of the cluster that will appear in the metrics."
  type        = string
}

variable "configuration" {
  description = "Map representing the additional configuration options (willl be merged with default configuration)."
  default     = {}
}

variable "image" {
  description = "Docker image to use."
  default     = "amazon/cloudwatch-agent"
}

variable "image_version" {
  description = "Version of the docker image to use."
  default     = "latest"
}

#####
# RBAC
#####

variable "service_account_name" {
  description = "Name of the service account to create."
  default     = "cloudwatch-agent"
}

variable "service_account_labels" {
  description = "Map of labels that will be applied on the service account."
  default     = {}
}

variable "service_account_annotations" {
  description = "Map of annotations that will be applied on the service account."
  default     = {}
}

variable "cluster_role_name" {
  description = "Name of the cluster role to create."
  default     = "cloudwatch-agent"
}

variable "cluster_role_labels" {
  description = "Map of labels that will be applied on the cluster role."
  default     = {}
}

variable "cluster_role_annotations" {
  description = "Map of annotations that will be applied on the cluster role."
  default     = {}
}

variable "cluster_role_binding_name" {
  description = "Name of the cluster role binding to create."
  default     = "cloudwatch-agent"
}

variable "cluster_role_binding_labels" {
  description = "Map of labels that will be applied on the cluster role binding."
  default     = {}
}

variable "cluster_role_binding_annotations" {
  description = "Map of annotations that will be applied on the cluster role binding."
  default     = {}
}

#####
# ConfigMap
#####

variable "config_map_name" {
  description = "Name of the config map to create."
  default     = "cloudwatch-agent"
}

variable "config_map_labels" {
  description = "Map of labels that will be applied on the config map."
  default     = {}
}

variable "config_map_annotations" {
  description = "Map of annotations that will be applied on the config map."
  default     = {}
}

#####
# Daemonset
#####

variable "daemonset_name" {
  description = "Name of the daemonset to create."
  default     = "cloudwatch-agent"
}

variable "daemonset_labels" {
  description = "Map of labels that will be applied on the daemonset."
  default     = {}
}

variable "daemonset_annotations" {
  description = "Map of annotations that will be applied on the daemonset."
  default     = {}
}

variable "daemonset_template_labels" {
  description = "Map of labels that will be applied on the daemonset template."
  default     = {}
}

variable "daemonset_template_annotations" {
  description = "Map of annotations that will be applied on the daemonset template."
  default     = {}
}

variable "automount_service_account_token" {
  description = "Whether or not to automatically mount the service account token."
  default     = true
}
