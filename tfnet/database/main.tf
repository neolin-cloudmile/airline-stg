variable "db_name" {}
variable "db_region" {}
variable "db_version" {}
variable "db_type" {}
variable "db_private_newtork" {}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${var.db_private_network}"
}
resource "google_service_networking_connection" "private_vpc_connection" {
  network       = "${var.db_private_network}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}
resource "google_sql_database_instance" "master" {
  name = "${var.db_name}"
  region = "${var.db_region}"
  database_version = "${var.db_version}"

  depends_on = [
    "google_service_networking_connection.private_vpc_connection"
  ]
  
  settings {
    tier = "${var.db_type}"
    disk_autoresize = "true"
    
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${var.db_private_network}" 
    }
  }
}
