variable "api_cert" {
            type = string
            default = "/full-path/X.crt"
        }
        
        //Certificate public key for API 

        variable "api_key" {
          type = string
          default = "/full-path/X.key"
        }
        //Certificate private key for API 

        variable "api_key" {
             type = string
             default = "<XC API KEY>"
        }
        //API KEY for XC
        
        variable "api_url" {
            type = string
            default = "https://<TENANT NAME>.console.ves.volterra.io/api"
        }

        variable "namespace" {
            type = string
            default = "default"
        }

        variable "owner" {
            type = string
            default = "<YOUR NAME>"
        }


        variable "fqdn" {
             type = string
             default = "<FULLY QUALIFIED DOMAIN NAME>"
        }

        //for ex: a.example.com

        variable "domain" {
             type = string
             default = "<DOMAIN>"
        }

        //for ex: example.com

        variable "app_name" {
             type = string
             default = "<APPLICATION NAME>"
        }

