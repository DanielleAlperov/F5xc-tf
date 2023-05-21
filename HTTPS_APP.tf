# HTTP Load Balancer for NGINX Servers
resource "volterra_http_loadbalancer"  "https_lb" { 
  depends_on = [volterra_origin_pool.my-pool-tf]
  name      = "${var.app_name}-lb"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  description                     = "${var.app_name} application created by TF"
  domains                         =  [var.fqdn]
  
  https {
    add_hsts = true
    http_redirect = true
    enable_path_normalize = true
    tls_parameters {
      no_mtls = true
      tls_config {
        default_security = true  
      }
tls_certificates {
        certificate_url = "string:///<BASE64 CERTIFICATE>"
        private_key {
          blindfold_secret_info {
             decryption_provider = ""
             store_provider = ""
             location = "string:///<BASE64 BLINDFOLDED KEY>"
          }
          secret_encoding_type = "EncodingNone"
      
        }
      }    
    }
  }
//Mandatory "VIP configuration"
advertise_on_public_default_vip = true
 round_robin                     = true
  default_route_pools {
    pool {
      name      = "${var.app_name}-pool" 
      namespace = var.namespace
    }
    weight   = 1
    priority = 1
  }
 
//End of mandatory "VIP configuration"
//Mandatory "Security configuration"
no_service_policies = true
no_challenge = true
disable_rate_limit = true
disable_waf = true
multi_lb_app = true
user_id_client_ip = true
//End of mandatory "Security configuration"
//Mandatory "Load Balancing Control"
source_ip_stickiness = true
//End of mandatory "Load Balancing Control"
  
}
//End of the file
