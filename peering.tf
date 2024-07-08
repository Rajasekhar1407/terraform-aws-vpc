resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  # 0 means false this resource will not run, 1 means true this resource will run peering will created
  vpc_id        = aws_vpc.main.id # The ID of the requester VPC, in our case expense-dev vpc
  peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id # acceptor VPC, in our case default vpc
  # this means if var.acceptor_vpc_id is empty then take "data.aws_vpc.default.id" else take "var.acceptor_vpc_id"
  auto_accept   = var.acceptor_vpc_id == "" ? true : false
  # this means if var.acceptor_vpc_id is empty then auto_accept is true else false

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = local.resource_name # expense-dev
    }
  )
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  # count is useful to control when resource is required. it must satisify this condition then only this resource will work(is peering required = true & acceptor_vpc_id should be empty)
  route_table_id = aws_route_table.public.id # public route table ID in expense-dev VPC
  destination_cidr_block = data.aws_vpc.default.cidr_block # acceptor cidr block in our case default vpc cidr block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id # peering connection ID
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id = aws_route_table.private.id # private route table ID in expense-dev VPC
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "database_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id = aws_route_table.database.id # database route table ID in expense-dev VPC
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "default_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id = data.aws_route_table.name.id # default vpc route table ID
  destination_cidr_block = var.cidr_block # expense-dev VPC cidr block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}