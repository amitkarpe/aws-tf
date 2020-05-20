provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}
resource "aws_key_pair" "auth" {
	key_name = "tf"
	public_key = "${file(var.public_key_path)}"
}
 
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.auth.id}"
}
