resource "aws_instance" "amazon_linux" {
  ami           = "ami-00b7ea845217da02c"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  tags = {
    Name = "c8.local"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  tags = {
    Name = "u21.local"
  }
}

