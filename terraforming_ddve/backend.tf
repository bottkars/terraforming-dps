terraform {
  # required_version = "< 0.12.0"

  #  backend "local" {
  #    path = "../terraform.tfstate"

  backend "s3" {
    bucket = "terraform"
    key    = "terraforming-dps/terraform.tfstate"
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true

 #   region= "EAST-US"
  }
}
