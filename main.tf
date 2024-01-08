provider "google" {
  credentials = file("C:\Users\narsupalliv\Downloads\gke-cluster-creation-test-63b4e54a6bb8.json")
  project     = "gke-cluster-creation-test"
  region      = "us-west1"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-west1"

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}