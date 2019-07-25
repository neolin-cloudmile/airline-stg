variable "redis_name" {}
variable "redis_region" {}
variable "redis_memory_size" {}
variable "redis_auth_network" {}
variable "redis_version" {}

resource "google_redis_instance" "cache" {
  name               = "${var.redis_name}"
  region             = "${var.redis_region}"
  memory_size_gb     = "${var.redis_memory_size}"
  authorized_network = "${var.redis_auth_network}"
  redis_version      = "${var.redis_version}" 
}
