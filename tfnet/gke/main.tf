variable "gke_name" {}
variable "gke_location" {}
variable "gke_init_node" {}
variable "gke_network" {}
variable "gke_subnetwork" {}

data "google_client_config" "current" {}
data "google_container_engine_versions" "default" {
  location = "${var.gke_location}"
}
resource "google_container_cluster" "tf-gke-k8s-dev" {
  name         = "${var.gke_name}"
  location     = "${var.gke_location}"
  initial_node_count = "${var.gke_init_node}"
  min_master_version = "${data.google_container_engine_versions.default.latest_master_version}"
  network            = "${var.gke_network}"
  subnetwork         = "${var.gke_subnetwork}"  

  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }
}
