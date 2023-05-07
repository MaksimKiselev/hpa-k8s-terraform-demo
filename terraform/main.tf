provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "events_endpoint" {
  metadata {
    name   = "events-endpoint"
    labels = {
      app = "events-endpoint"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "events-endpoint"
      }
    }

    template {
      metadata {
        name   = "events-endpoint"
        labels = {
          app = "events-endpoint"
        }
      }

      spec {
        container {
          name              = "events-endpoint"
          image             = var.events_endpoint_docker_image
          image_pull_policy = "Always"
          command           = [
            "npm",
            "start"
          ]
          resources {
            requests = {
              cpu    = "10m"
              memory = "50Mi"
            }
            limits = {
              cpu    = "20m"
              memory = "75Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "events_endpoint" {
  metadata {
    name = "events-endpoint"
  }

  spec {
    selector = {
      app = kubernetes_deployment.events_endpoint.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress"
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service.events_endpoint.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "events_endpoint" {
  metadata {
    name = "events-endpoint"
  }

  spec {
    max_replicas = 10
    min_replicas = kubernetes_deployment.events_endpoint.spec[0].replicas
    target_cpu_utilization_percentage = 80
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.events_endpoint.metadata[0].name
    }
  }
}