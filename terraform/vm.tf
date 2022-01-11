resource "google_compute_instance" "privare_vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
     network = google_compute_network.vpc_network.id 
     subnetwork = google_compute_subnetwork.Management.id
  }
}

