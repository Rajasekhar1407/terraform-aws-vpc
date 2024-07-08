output "azs" {
  value = data.aws_availability_zones.available
}

output "aws_vpc" {
  value = data.aws_vpc.default
}

output "vpc_id" {
  value = aws_vpc.main.id
}