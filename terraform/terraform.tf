terraform {
  required_version = "> 1.5"
}

provider "kubernetes" {
  config_context = "k8s-config"
}

resource "kubernetes_deployment_v1" "nginx" {
    metadata {
        name = "nginx"
        labels = {
            app   = "nginx"
        }
    }
    
    spec {
        selector {
            match_labels = {
                app   = "nginx.app"
            }
        }
        replicas = 1
        template { 
            metadata {
                labels = {
                    app   = "nginx"
                }
            }
            spec {
                container {
                    image = "nginx:1.24.0"
                    name  = "nginx"
                    
                    port { 
                        container_port = 80
                    }
                    
                    resources {
                        requests = {
                            cpu    = "1"
                            memory = "1024Mi"
                        }
                        limits = {
                            cpu    = "2"
                            memory = "2048Mi"
                        }
                    }
                    node_selector {
                        "dedicated" = "dev"
                    }
                    toleration {
                        effect = "NoExecute"
                        key    = "dedicated"
                        value  = "dev"
                    }
                }
            }
        }
    }
}

resource "kubernetes_service_v1" "nginx.svc" {
  metadata {
    name = "nginx.svc"
  }
  spec {
    selector = {
      app = nginx.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = nginx.svc
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

