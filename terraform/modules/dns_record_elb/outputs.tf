output "name_servers" {
  description = ""
  value       = "${data.aws_route53_zone.parent.name_servers}"
}

output "subdomain_fqdn" {
  description = "Full qualified domain name of the subdomain record that was created"
  value       = "${aws_route53_record.subdomain.fqdn}"
}
