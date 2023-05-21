resource "null_resource" "create_cname" {
  depends_on = [volterra_http_loadbalancer.https_lb]
  provisioner "local-exec" {
  command = "bash /Users/d.alperov/Desktop/terraform/tcs/create_cname_record.sh ${var.app_name} ${var.domain} ${var.app_name}-lb ${var.api_url} ${var.api_key}"
  }
}