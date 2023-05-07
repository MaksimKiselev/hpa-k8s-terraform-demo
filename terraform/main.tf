#provider "kubernetes" {
#  config_path = "~/.kube/config"
#}
#
#resource "kubernetes_deployment" "events_endpoint" {
#  metadata {
#    name = "events-endpoint"
#    labels = {
#      app = "events-endpoint"
#    }
#  }
#  spec {
#    replicas = terraform.workspace == "prod" ? 2 : 1
#
#    selector {
#      match_labels = {
#        app = "events-endpoint"
#      }
#    }
#
#    template {
#      metadata {
#        name = "events-endpoint"
#        labels = {
#          app = "events-endpoint"
#        }
#      }
#
#      spec {
#        container {
#          name = "events-endpoint"
#          image = var.events_endpoint_docker_image
#          image_pull_policy = "Always"
#          command = [
#            "npm",
#            "start"
#          ]
#          resources {
#            requests = {
#              cpu = "400m"
#              memory = "200Mi"
#            }
#            limits = {
#              cpu = "600m"
#              memory = "400Mi"
#            }
#          }
#          volume_mount {
#            name = "service-account-credentials"
#            read_only = true
#            mount_path = "/secrets/service-account"
#          }
#          env {
#            name = "GET_HOSTS_FROM"
#            value = "dns"
#          }
#          env {
#            name = "NODE_ENV"
#            value_from {
#              config_map_key_ref {
#                name = "events-endpoint-env-vars"
#                key = "NODE_ENV"
#              }
#            }
#          }
#        }
#        volume {
#          name = "service-account-credentials"
#          secret {
#            secret_name = "events-endpoint-service-account-credentials"
#          }
#        }
#      }
#    }
#  }
#}
