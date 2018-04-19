output "subdomain_fqdn" {
  description = "Full qualified domain name of the subdomain record that was created"
  value       = "${aws_route53_record.subdomain.fqdn}"
}
