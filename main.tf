#####
# Locals
#####

locals {
  labels = {
    version    = var.image_version
    part-of    = "monitoring"
    managed-by = "terraform"
    name       = "cloudwatch-agent"
  }
  annotations = {}
  configuration = merge(
    {
      logs = {
        metrics_collected = {
          kubernetes = {
            cluster_name                = var.cluster_name
            metrics_collection_interval = 60
          }
        }
        force_flush_interval = 5
      }
    },
    var.configuration
  )
}

#####
# Randoms
#####

resource "random_string" "selector" {
  count = var.enabled ? 1 : 0

  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# RBAC
#####

resource "kubernetes_service_account" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    labels = merge(
      {
        instance  = var.service_account_name
        component = "rbac"
      },
      local.labels,
      var.labels,
      var.service_account_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.service_account_annotations
    )
  }
}

resource "kubernetes_cluster_role" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.cluster_role_name
    labels = merge(
      {
        instance  = var.cluster_role_name
        component = "rbac"
      },
      local.labels,
      var.labels,
      var.cluster_role_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.cluster_role_annotations
    )
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "endpoints"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/proxy"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/stats", "configmaps", "events"]
    verbs      = ["create"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cwagent-clusterleader"]
    verbs          = ["get", "update"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.cluster_role_binding_name
    labels = merge(
      {
        instance  = var.cluster_role_binding_name
        component = "rbac"
      },
      local.labels,
      var.labels,
      var.cluster_role_binding_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.cluster_role_binding_annotations
    )
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = element(concat(kubernetes_cluster_role.this.*.metadata.0.name, list("")), 0)
  }

  subject {
    kind      = "ServiceAccount"
    name      = element(concat(kubernetes_service_account.this.*.metadata.0.name, list("")), 0)
    namespace = element(concat(kubernetes_service_account.this.*.metadata.0.namespace, list("")), 0)
  }
}

#####
# ConfigMap
#####

resource "kubernetes_config_map" "this" {
  metadata {
    name      = var.config_map_name
    namespace = var.namespace
    labels = merge(
      {
        instance  = var.config_map_name
        component = "configuration"
      },
      local.labels,
      var.labels,
      var.config_map_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.config_map_annotations
    )
  }

  data = {
    cwagentconfig = jsonencode(local.configuration)
  }
}

#####
# Daemonset
#####

resource "kubernetes_daemonset" "this" {
  metadata {
    name      = var.daemonset_name
    namespace = var.namespace
    labels = merge(
      {
        instance  = var.daemonset_name
        component = "application"
      },
      local.labels,
      var.labels,
      var.daemonset_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.daemonset_annotations
    )
  }

  spec {
    selector {
      match_labels = {
        selector = "cloudwatch-agent-${element(concat(random_string.selector.*.result, list("fake")), 0)}"
      }
    }

    template {
      metadata {
        name = var.daemonset_name
        labels = merge(
          {
            instance  = var.daemonset_name
            component = "application"
            selector  = "cloudwatch-agent-${element(concat(random_string.selector.*.result, list("fake")), 0)}"
          },
          local.labels,
          var.labels,
          var.daemonset_template_labels
        )
        annotations = merge(
          {},
          local.annotations,
          var.annotations,
          var.daemonset_template_annotations
        )
      }


      spec {
        automount_service_account_token  = var.automount_service_account_token
        service_account_name             = element(concat(kubernetes_service_account.this.*.metadata.0.name, list("")), 0)
        termination_grace_period_seconds = 60

        toleration {
          operator = "Exists"
        }

        container {
          name  = "cloudwatch-agent"
          image = "${var.image}:${var.image_version}"

          resources {
            limits {
              cpu    = "200m"
              memory = "200Mi"
            }
            requests {
              cpu    = "200m"
              memory = "200Mi"
            }
          }

          env {
            name = "HOST_IP"
            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }

          env {
            name = "HOST_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "K8S_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "CI_VERSION"
            value = "k8s/1.1.1"
          }

          volume_mount {
            name       = "cloudwatch-agent-config"
            mount_path = "/etc/cwagentconfig"
            read_only  = true
          }

          volume_mount {
            name       = "rootfs"
            mount_path = "/rootfs"
            read_only  = true
          }

          volume_mount {
            name       = "dockersock"
            mount_path = "/var/run/docker.sock"
            read_only  = true
          }

          volume_mount {
            name       = "varlibdocker"
            mount_path = "/var/lib/docker"
            read_only  = true
          }

          volume_mount {
            name       = "sys"
            mount_path = "/sys"
            read_only  = true
          }

          volume_mount {
            name       = "devdisk"
            mount_path = "/dev/disk"
            read_only  = true
          }
        }

        volume {
          name = "cloudwatch-agent-config"
          config_map {
            name = element(concat(kubernetes_config_map.this.*.metadata.0.name, list("")), 0)
          }
        }

        volume {
          name = "rootfs"
          host_path {
            path = "/"
          }
        }

        volume {
          name = "dockersock"
          host_path {
            path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "varlibdocker"
          host_path {
            path = "/var/lib/docker"
          }
        }

        volume {
          name = "sys"
          host_path {
            path = "/sys"
          }
        }

        volume {
          name = "devdisk"
          host_path {
            path = "/dev/disk"
          }
        }
      }
    }
  }
}
