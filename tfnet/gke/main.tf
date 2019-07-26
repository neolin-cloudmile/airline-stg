variable "cluster_name" {}
variable "cluster_location" {}
variable "cluster_init_node" {}
variable "cluster_network" {}
variable "cluster_subnetwork" {}
variable "cluster_secondary_rangename" {}
variable "cluster_service_secondary_rangename" {}

data "google_client_config" "current" {}
data "google_container_engine_versions" "default" {
  location = "${var.cluster_location}"
}
resource "google_container_cluster" "tf-gke-k8s-dev" {
  name         = "${var.cluster_name}"
  location     = "${var.cluster_location}"
  initial_node_count = "${var.cluster_init_node}"
  min_master_version = "${data.google_container_engine_versions.default.latest_master_version}"
  network            = "${var.cluster_network}"
  subnetwork         = "${var.cluster_subnetwork}"  

  private_cluster_config {
    enable_private_nodes   = "true"
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
  master_authorized_networks_config {
    cidr_blocks {
      # In your Cloud Shell command-line window, use dig to find the external IP address of your Cloud Shell
      cidr_block   = "35.234.46.81/32"
      display_name = "all-for-testing"
    }
  }
  # ip_allocation_policy.use_ip_aliases defaults to true, since we define the block `ip_allocation_policy`
  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.cluster_secondary_rangename}"
    services_secondary_range_name = "${var.cluster_service_secondary_rangename}"
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }
}
