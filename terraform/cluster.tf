resource "google_container_cluster" "primary" {
 name = "myapp"
 location = "us-central1"
 initial_node_count = 1
 enable_autopilot = false
 network = google_compute_network.vpc_network.id 
 subnetwork = google_compute_subnetwork.Restricted.id

 node_config {
 service_account = google_service_account.access.email
 
 }
ip_allocation_policy{
    
}
##to allow only VM that in mangment subnetwork 
master_authorized_networks_config  {
    cidr_blocks {
      cidr_block   = "10.1.0.0/16"
      display_name = "management"
    }
  }

##to make master in private network 
  private_cluster_config {
      master_ipv4_cidr_block = "172.16.0.0/28"
      enable_private_nodes = true
      enable_private_endpoint = true
  }

}


### create service account
resource "google_service_account" "access" {
 account_id = "cluster-service-account"
 display_name = "cluster_service_account"
}

### binding service account
resource "google_project_iam_binding" "service_account_binding" {
 project = "positive-bonbon-337300"
 role = "roles/container.clusterAdmin"
 members = [
 "serviceAccount:cluster-service-account@positive-bonbon-337300.iam.gserviceaccount.com",
 ]
 depends_on = [google_service_account.access]
}
