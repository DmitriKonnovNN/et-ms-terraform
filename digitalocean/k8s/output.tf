output "my_ip" {
  value       = var.my_public_ip
  description = "IP of my local machine"

}

output "project_name" {
  value       = digitalocean_project.exam-micro-services.name
  description = "project name"
}

output "project_id" {
  value       = digitalocean_project.exam-micro-services.id
  description = "project id"
}

output "project_env" {
  value       = digitalocean_project.exam-micro-services.environment
  description = "project environment"
}

output "k8s_version" {
  value = data.digitalocean_kubernetes_versions.k8s-version-1-24-latest.latest_version
}

output "k8s_cluster" {
  value     = digitalocean_kubernetes_cluster.exam-microsvcs-k8s-cluster
  sensitive = true
}

output "postgres_cluster" {
  value     = digitalocean_database_cluster.postgres-cluster
  sensitive = true
}

output "postgres_dbs" {
  value     = digitalocean_database_db.databases
  sensitive = true
}

output "postgres_connection_pools" {
  value     = digitalocean_database_connection_pool.pools
  sensitive = true
}

output "postgres_users" {
  value     = digitalocean_database_user.postgres_user
  sensitive = true
}