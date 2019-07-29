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
    backup_configuration {
      binary_log_enabled = "true" 
      enabled = "true"
      start_time = "${var.db_backup_time}"
    }
    maintenance_window {
      day = "${var.db_maintenance_day}"
      hour = "${var.db_maintenance_hour}"
      update_track = "stable"
    }
    disk_size = "${var_db_disk_size}"
    disk_type = "${var_db_disk_type}"
  }
}
resource "google_sql_database_instance" "read_replica" {
  count = var.num_read_replicas

  depends_on = [
    google_sql_database_instance.master,
    google_sql_database_instance.failover_replica,
    google_sql_database.default,
    google_sql_user.default,
  ]

  provider         = "google-beta"
  name             = "${var.name}-read-${count.index}"
  project          = var.project
  region           = var.region
  database_version = var.engine

  # The name of the instance that will act as the master in the replication setup.
  master_instance_name = google_sql_database_instance.master.name

  replica_configuration {
    # Specifies that the replica is not the failover target.
    failover_target = false
  }

  settings {
    tier                        = var.machine_type
    authorized_gae_applications = var.authorized_gae_applications
    disk_autoresize             = var.disk_autoresize

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }

      ipv4_enabled    = var.enable_public_internet_access
      private_network = var.private_network
      require_ssl     = var.require_ssl
    }
    disk_size = var.disk_size
    disk_type = var.disk_type
  }
}
