output "frontend_ip" {
  value = aws_instance.amazon_linux.public_ip
}

output "backend_ip" {
  value = aws_instance.ubuntu.public_ip
}

