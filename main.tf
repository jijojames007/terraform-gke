provider "google" {
  credentials = "${file("k8s-cred.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

provider "google-beta" {
  credentials = "${file("k8s-cred.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_container_cluster" "k8sexample" {
  provider 	     = "google"
  name               = "${var.cluster-name}"
  description        = "example k8s cluster"
  zone	             = "${var.gcp_zone}"
  initial_node_count = "${var.initial_node_count}"
  enable_kubernetes_alpha = "false"
  enable_legacy_abac = "true"
#  enable_private_nodes = "true"
  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"

    client_certificate_config {
      issue_client_certificate = true
    }
  }
  
  private_cluster_config {
            enable_private_endpoint = false
            enable_private_nodes    = true
            master_ipv4_cidr_block  = "10.5.0.0/28"
        }
  ip_allocation_policy {
	use_ip_aliases    = true
        }
#}
  node_config {
    image_type   = "COS"
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]

#    labels = {
#      private-pools-example = "true"
#    }

    # Add a private tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
#    tags = [
#      "module.vpc_network.private",
#      "private-pool-example",
#    ]

    disk_size_gb = "20"
    disk_type    = "pd-standard"
    preemptible  = false


    timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
 }
# CREATE A NODE POOL ###################################################################
}
