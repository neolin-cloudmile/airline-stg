variable "redis_name" {}
variable "redis_tier" {}
variable "redis_region" {}
variable "redis_zone" {}
variable "redis_alt_zone" {}
variable "redis_memory_size" {}
variable "redis_auth_network" {}
variable "redis_version" {}

resource "google_redis_instance" "cache" {
  name                    = "${var.redis_name}"
  tier                    = "${var.redis_tier}"
  region                  = "${var.redis_region}"
  location_id             = "${var.redis_zone}"
  alternative_location_id = "${var.redis_alt_zone}"
  memory_size_gb          = "${var.redis_memory_size}"
  authorized_network      = "${var.redis_auth_network}"
  redis_version           = "${var.redis_version}" 
}
