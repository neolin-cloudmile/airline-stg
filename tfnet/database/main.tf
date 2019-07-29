variable "db_name" {}
variable "db_region" {}
variable "db_version" {}
variable "db_type" {}
variable "db_private_newtork" {}
variable "db_backup_time" {}
variable "db_maintenance_day" {}
variable "db_maintenance_hour" {}
variable "db_disk_size" {}
variable "db_disk_type" {}
variable "db_name_failover" {}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${var.db_private_network}"
}
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "${var.db_private_network}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}
resource "google_sql_database_instance" "master" {
  name             = "${var.db_name}"
  region           = "${var.db_region}"
  database_version = "${var.db_version}"

  depends_on = [ "google_service_networking_connection.private_vpc_connection" ]
  
  settings {
    tier            = "${var.db_type}"
    disk_autoresize = "true"
    
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${var.db_private_network}" 
    }
    backup_configuration {
      binary_log_enabled = "true" 
      enabled            = "true"
      start_time         = "${var.db_backup_time}"
    }
    maintenance_window {
      day          = "${var.db_maintenance_day}"
      hour         = "${var.db_maintenance_hour}"
      update_track = "stable"
    }
    disk_size = "${var_db_disk_size}"
    disk_type = "${var_db_disk_type}"
  }
}
resource "google_sql_database_instance" "failover_replica" {
  count = "1"

  depends_on = [ google_sql_database_instance.master ]
  name             = "${var.db_name_failover}"
  region           = "${var.db_region}"
  database_version = "${var.db_version}"
  master_instance_name = "google_sql_database_instance.master.name"

  replica_configuration {
    failover_target = "true"
  }
  settings {
    crash_safe_replication = "true"
    tier                   = "${var.db_type}"
    disk_autoresize        = "true"
    
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${var.db_private_network}"
    }
    disk_size = "${var.db_disk_size}"
    disk_type = "${var.db_disk_type}"
  }
}
