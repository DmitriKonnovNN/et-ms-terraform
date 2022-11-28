#data "http" "my_public_ip" {
#
#  url = "https://ifconfig.co/json"
#  request_headers = {
#    Accept = "application/json"
#  }
#}

data "digitalocean_kubernetes_versions" "k8s-version-1-24-latest" {
  version_prefix = "1.24."
}