# Create the official-website-dev network
 resource "google_compute_network" "official-website-dev" {
  name = "official-website-dev"
  auto_create_subnetworks = "false"
}
# Create official-website-dev subnetwork
resource "google_compute_subnetwork" "public-subnet-1" {
  name          = "public-subnet-1"
  region        = "asia-east1"
  network       = "${google_compute_network.official-website-dev-network.self_link}"
  ip_cidr_range = "10.240.66.0/24"
  private_ip_google_access = "true"
}
