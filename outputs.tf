output "service_account" {
  value = element(concat(kubernetes_service_account.this.*, list({})), 0)
}

output "cluster_role" {
  value = element(concat(kubernetes_cluster_role.this.*, list({})), 0)
}

output "cluster_role_binding" {
  value = element(concat(kubernetes_cluster_role_binding.this.*, list({})), 0)
}

output "config_map" {
  value = element(concat(kubernetes_config_map.this.*, list({})), 0)
}

output "daemonset" {
  value = element(concat(kubernetes_daemonset.this.*, list({})), 0)
}
