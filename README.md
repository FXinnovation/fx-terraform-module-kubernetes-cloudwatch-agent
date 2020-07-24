# terraform-module-kubernetes-cloudwatch-agent

Terraform module that deploy the needed resources to deploy the cloudwatch-agent on kubernetes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Map of annotations that will be applied on all kubernetes resources. | `map` | `{}` | no |
| automount\_service\_account\_token | Whether or not to automatically mount the service account token. | `bool` | `true` | no |
| cluster\_name | Name of the cluster that will appear in the metrics. | `string` | n/a | yes |
| cluster\_role\_annotations | Map of annotations that will be applied on the cluster role. | `map` | `{}` | no |
| cluster\_role\_binding\_annotations | Map of annotations that will be applied on the cluster role binding. | `map` | `{}` | no |
| cluster\_role\_binding\_labels | Map of labels that will be applied on the cluster role binding. | `map` | `{}` | no |
| cluster\_role\_binding\_name | Name of the cluster role binding to create. | `string` | `"cloudwatch-agent"` | no |
| cluster\_role\_labels | Map of labels that will be applied on the cluster role. | `map` | `{}` | no |
| cluster\_role\_name | Name of the cluster role to create. | `string` | `"cloudwatch-agent"` | no |
| config\_map\_annotations | Map of annotations that will be applied on the config map. | `map` | `{}` | no |
| config\_map\_labels | Map of labels that will be applied on the config map. | `map` | `{}` | no |
| config\_map\_name | Name of the config map to create. | `string` | `"cloudwatch-agent"` | no |
| configuration | Map representing the additional configuration options (willl be merged with default configuration). | `map` | `{}` | no |
| daemonset\_annotations | Map of annotations that will be applied on the daemonset. | `map` | `{}` | no |
| daemonset\_labels | Map of labels that will be applied on the daemonset. | `map` | `{}` | no |
| daemonset\_name | Name of the daemonset to create. | `string` | `"cloudwatch-agent"` | no |
| daemonset\_template\_annotations | Map of annotations that will be applied on the daemonset template. | `map` | `{}` | no |
| daemonset\_template\_labels | Map of labels that will be applied on the daemonset template. | `map` | `{}` | no |
| enabled | Whether or not to enable this module. | `bool` | `true` | no |
| image | Docker image to use. | `string` | `"amazon/cloudwatch-agent"` | no |
| image\_version | Version of the docker image to use. | `string` | `"latest"` | no |
| labels | Map of labels that will be applied on all kubernetes resources. | `map` | `{}` | no |
| namespace | Namespace in which the module will be deployed. | `string` | `"kube-system"` | no |
| service\_account\_annotations | Map of annotations that will be applied on the service account. | `map` | `{}` | no |
| service\_account\_labels | Map of labels that will be applied on the service account. | `map` | `{}` | no |
| service\_account\_name | Name of the service account to create. | `string` | `"cloudwatch-agent"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_role | n/a |
| cluster\_role\_binding | n/a |
| config\_map | n/a |
| daemonset | n/a |
| service\_account | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.
