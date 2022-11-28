variable "owner" {
  type = string
}
variable "region" {
  type = string
}

variable "token" {
  type = string
}

variable "droplet_names" {
  type = list(string)
}
variable "node_size" {
  type = string
}

variable "db_size" {
  type    = string
  default = "db-s-1vcpu-1gb"
}

variable "image_type" {
  type = string
}

variable "project_name" {
  type    = string
  default = "exam-microservices"

}

variable "my_public_ip" {
  type = string

}

variable "pub_key_path" {
  type = string
}

variable "app_name" {
  type    = string
  default = "LL-Evaluator"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "all_traffic_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0", "::/0"]
}

variable "all_ports" {
  type    = string
  default = "1-65535"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "provisioning_type" {
  type    = string
  default = "tf"
}

variable "db_names" {
  type    = list(string)
  default = ["customer", "fraud", "notification"]
}