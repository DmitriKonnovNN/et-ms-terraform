resource "digitalocean_database_cluster" "postgres-cluster" {
  name       = "postgres-cluster"
  engine     = "pg"
  version    = "13"
  size       = var.db_size
  region     = var.region
  node_count = 1
  tags       = [for tag in digitalocean_tag.k8s-tags : tag.id]


  maintenance_window {
    day  = "sunday"
    hour = "04:00:00"
  }
}


resource "digitalocean_database_db" "databases" {
  for_each   = toset(var.db_names)
  cluster_id = digitalocean_database_cluster.postgres-cluster.id
  name       = each.value
}

resource "digitalocean_database_connection_pool" "pools" {
  for_each   = digitalocean_database_user.postgres_user
  cluster_id = digitalocean_database_cluster.postgres-cluster.id
  name       = "${each.value.name}-pool"
  mode       = "transaction"
  size       = 6
  db_name    = each.value
  user       = each.value.name
  depends_on = [digitalocean_database_db.databases]
}

resource "digitalocean_database_user" "postgres_user" {
  for_each   = toset(var.db_names)
  cluster_id = digitalocean_database_cluster.postgres-cluster.id
  name       = "${each.value}-service"
}

resource "digitalocean_tag" "k8s-tags" {
  for_each = toset([lower(var.app_name), var.env, var.owner, var.provisioning_type])
  name     = each.value
}
