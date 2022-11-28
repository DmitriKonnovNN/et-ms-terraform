terraform {
  cloud {
    organization = "dmitriv-konnov-solutions"

    workspaces {
      name = "exam-infra-dev"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13.2"
}

provider "digitalocean" {
  token = var.token
}

resource "digitalocean_project" "exam-micro-services" {
  name        = var.app_name
  description = "Bundle of all exam microservices."
  purpose     = "Full-Stack-App"
  environment = var.env
  resources   = [digitalocean_kubernetes_cluster.exam-microsvcs-k8s-cluster.urn, digitalocean_database_cluster.postgres-cluster.urn]
}

resource "digitalocean_kubernetes_cluster" "exam-microsvcs-k8s-cluster" {
  name         = "${var.app_name}-k8s-cluster"
  region       = var.region
  auto_upgrade = true
  ha           = false
  version      = data.digitalocean_kubernetes_versions.k8s-version-1-24-latest.latest_version

  node_pool {
    name       = "worker-pool"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 2
    size       = var.node_size
    node_count = var.node_count

    taint {
      key    = "workloadKind"
      value  = "database"
      effect = "NoSchedule"
    }
  }

  maintenance_policy {
    day        = "sunday"
    start_time = "02:00"
  }
  tags = [for tag in digitalocean_tag.k8s-tags : tag.id]
}
