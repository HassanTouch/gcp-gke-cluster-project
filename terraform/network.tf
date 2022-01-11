resource "google_compute_network" "vpc_network" {
  
  name                    = "gke-vpc"
  auto_create_subnetworks = false
  
}

resource "google_compute_subnetwork" "Management" {
  name          = "management"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  

 
}
resource "google_compute_subnetwork" "Restricted" {
  name          = "restricted"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id

 
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.Management.region
  network = google_compute_network.vpc_network.id

 
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.Management.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


####allow IAP 
resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]

}