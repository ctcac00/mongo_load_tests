
#
# Configure the MongoDB Atlas Provider
#
terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}
provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}


#
# Create a Shared Tier Cluster
#
resource "mongodbatlas_cluster" "loadtestDemo" {
  project_id              = var.atlasprojectid
  name                    = "loadtestDemo" 
  num_shards                   = var.num_shards
  replication_factor           = 3
  cloud_backup      = false
  auto_scaling_disk_gb_enabled = var.auto_scaling_disk_gb_enabled
  mongo_db_major_version       = var.mongo_db_major_version

  # Provider settings
  provider_name               = var.atlas_provider_name
  provider_instance_size_name = var.atlas_provider_instance_size_name
  provider_region_name        = var.cluster_region
  }

# Use terraform output to display connection strings.
output "connection_strings" {
  value = ["${mongodbatlas_cluster.loadtestDemo.connection_strings}"]
}