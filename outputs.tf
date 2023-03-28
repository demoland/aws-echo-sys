output ips {
  description = "Public IPs of the webservers"
  value = aws_instance.example.*.public_ip
}