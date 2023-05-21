
resource "volterra_origin_pool" "my-pool-tf" {
  name                   = "${var.app_name}-pool"
  namespace              = var.namespace
  no_tls                 = true
  port                   = "80"
  endpoint_selection     = "LOCALPREFERED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  origin_servers {
    // One of the arguments from this list "vn_private_name public_ip public_name private_ip private_name k8s_service consul_service vn_private_ip custom_endpoint_object" must be set

    public_name {
      dns_name = "<FQDN of Application>"
    }

    labels = {
      "owner" = var.owner
    }
  }
}


