resource "google_container_cluster" "primary" {
 name = "myapp"
 location = "us-central1-a"
  remove_default_node_pool = true
 initial_node_count = 1

  


 network = google_compute_network.vpc_network.id 
 subnetwork = google_compute_subnetwork.Restricted.id
 


ip_allocation_policy{
   cluster_ipv4_cidr_block  = "10.3.0.0/16"
   services_ipv4_cidr_block = "10.4.0.0/16"
    
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

## crate nodes 
 resource "google_container_node_pool" "node_pool" {
  name       = "node1"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  





  }

### create service account
resource "google_service_account" "access" {
 account_id = "cluster-service-account"
 display_name = "cluster_service_account"
}

### binding role  container.clusterAdmin to service account
resource "google_project_iam_binding" "role_1" {
 project = "webappgke"
 role = "roles/container.admin"
 members = [
 "serviceAccount:cluster-service-account@webappgke.iam.gserviceaccount.com",
 ]
 depends_on = [google_service_account.access]
}

### binding role  container.clusterAdmin to service account
resource "google_project_iam_binding" "role_2" {
 project = "webappgke"
 role = "roles/storage.objectAdmin"
 members = [
 "serviceAccount:cluster-service-account@webappgke.iam.gserviceaccount.com",
 ]
 depends_on = [google_service_account.access]
}



