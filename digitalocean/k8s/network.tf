locals {
  #  my_public_ip          = jsondecode(data.http.my_public_ip.response_body)
  protocols             = ["tcp", "udp", "icmp"]
  private_inbound_ports = ["22", "8080", "443", "30000-32000"]
}
#
#resource "digitalocean_firewall" "k8s-fw" {
#  name = "${var.app_name}-firewall"
#  droplet_ids = [for node in digitalocean_kubernetes_cluster.exam-microsvcs-k8s-cluster.node_pool[0].nodes : node.droplet_id]
#
#  dynamic "inbound_rule" {
#    for_each = local.private_inbound_ports
#    iterator = item
#    content {
#      port_range       = item.value
#      protocol         = "tcp"
#      source_addresses = [var.my_public_ip]
#    }
#  }
#
#  dynamic "outbound_rule" {
#    for_each = local.protocols
#    iterator = item
#    content {
#      protocol              = item.value
#      port_range            = var.all_ports
#      destination_addresses = var.all_traffic_cidr
#    }
#  }
#
#  tags = [for tag in digitalocean_tag.k8s-tags : tag.id]
#
#}

resource "digitalocean_database_firewall" "database-fw" {
  cluster_id = digitalocean_database_cluster.postgres-cluster.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.exam-microsvcs-k8s-cluster.id
  }

  rule {
    type  = "ip_addr"
    value = var.my_public_ip
  }
}
