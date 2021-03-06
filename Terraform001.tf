resource "google_compute_instance" "instance1" {
  name         = "instance1"                 # Nom
  machine_type = "n1-standard-1"             # Taille de la machine
  zone         = "northamerica-northeast1-a" # Zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8" # Disque
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.cr460-subnet1.self_link}" # Interface Reseau
  }

  tags = ["web", "cr-460", "cr460-network"]
}

#Definition du sous-reseau
resource "google_compute_subnetwork" "cr460-subnet1" {
  name          = "cr460-subnet1"                             # Nom
  ip_cidr_range = "10.0.0.0/24"                               # Adresse IP
  network       = "${google_compute_network.cr460-network.self_link}" # Liens vers le reseau
  region        = "northamerica-northeast1"                   # Region
}

# Definition du VPC
resource "google_compute_network" "cr460-network" {
  name                    = "cr460-network" # Nom du reseau
  auto_create_subnetworks = "false"
}

resource "google_compute_firewall" "http" {
  name    = "http"
  network = "${google_compute_network.cr460-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["web"]
}
resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = "${google_compute_network.cr460-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["linux"]
}
# Definir le fournisseur nuagique
provider "google" {
  credentials = "${file("CR-460-511eda8dc1ca.json")}"
  project     = "cr-460"
  region      = "northamerica-northeast1"
}
