# Create the official-website-dev network
 resource "google_compute_network" "official-website-dev" {
  name = "official-website-dev"
  auto_create_subnetworks = "false"
}
# Create public-subnet-1 subnetwork
resource "google_compute_subnetwork" "public-subnet-1" {
  name          = "public-subnet-1"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev.self_link}"
  ip_cidr_range = "10.240.66.0/24"
  private_ip_google_access = "true"
}
# Create public-subnet-2 subnetwork
resource "google_compute_subnetwork" "public-subnet-2" {
  name          = "public-subnet-2"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev.self_link}"
  ip_cidr_range = "10.240.68.0/24"
  private_ip_google_access = "true"
}
# Create private-subnet-1 subnetwork
resource "google_compute_subnetwork" "private-subnet-1" {
  name          = "private-subnet-1"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev.self_link}"
  ip_cidr_range = "10.240.70.0/24"
  private_ip_google_access = "true"
}
# Create private-subnet-2 subnetwork
resource "google_compute_subnetwork" "private-subnet-2" {
  name          = "private-subnet-2"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev.self_link}"
  ip_cidr_range = "10.240.72.0/24"
  private_ip_google_access = "true"
}
# Create private-subnet-k8s subnetwork
resource "google_compute_subnetwork" "private-subnet-k8s" {
  name          = "private-subnet-k8s"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev.self_link}"
  ip_cidr_range = "10.240.76.0/23"
  private_ip_google_access = "true"
}
# Add a firewall rule to allow SSH traffic on official-website-dev
resource "google_compute_firewall" "official-website-dev-allow-ssh" {
  name = "official-website-dev-allow-ssh"
  network = "${google_compute_network.official-website-dev.self_link}"
  allow {
      protocol = "tcp"
      ports    = ["22"] 
  }
  target_tags = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
}
