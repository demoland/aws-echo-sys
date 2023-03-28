output ips {
  description = "Public IPs of the webservers"
  value = "${aws_instance.web.*.public_ip}"
}