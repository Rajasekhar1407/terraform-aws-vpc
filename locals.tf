locals {
  resource_name = "${var.project_name}-${var.environment}"
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)
  # this will consider 0 and 1 elements only 2 is exclusive
}