resource "aws_security_group" "kubesg" {
  name = var.clustersg
  description = "this is to allow the server outside"
  vpc_id = aws_vpc.kubernetesvpc.id
  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "kubernetesvpc" {
  cidr_block = var.block1
  tags = {
    name = var.vpcname
  }
}

resource "aws_subnet" "pubsub01" {
  cidr_block = var.block2
  availability_zone = "eu-north-1a"
  vpc_id = aws_vpc.kubernetesvpc.id
  map_public_ip_on_launch = true
  tags = {
    name = var.pubsub01
  }
}

resource "aws_subnet" "pubsub02" {
  cidr_block = var.block3
  availability_zone = "eu-north-1b"
  vpc_id = aws_vpc.kubernetesvpc.id
  map_public_ip_on_launch = true
  tags = {
    name = var.pubsub02
  }
}

resource "aws_internet_gateway" "internetgate" {
  vpc_id = aws_vpc.kubernetesvpc.id
}

resource "aws_route_table" "routetable1" {
  vpc_id = aws_vpc.kubernetesvpc.id
  route {
    cidr_block = var.block4
    gateway_id = aws_internet_gateway.internetgate.id
  }
}

resource "aws_route_table_association" "routeassociation1" {
  route_table_id = aws_route_table.routetable1.id
  subnet_id = aws_subnet.pubsub01.id
}
resource "aws_route_table_association" "routeassociation2" {
  route_table_id = aws_route_table.routetable1.id
  subnet_id = aws_subnet.pubsub02.id
}
