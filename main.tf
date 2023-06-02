# Configure the AWS provider

provider "aws" {
  region = "us-west-1"  # Replace with your desired region
  access_key = "\"
  secret_key = "\"
}



# Create a VPC

resource "aws_vpc" "wordpress_vpc" {
  cidr_block = "10.0.0.0/16"
	
	tags = {
		Name = "wordpress-vpc"
	}
}


# Create a public subnet

resource "aws_subnet" "wordpress_public_subnet" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = "10.0.1.0/24"

	tags = {
		Name = "wordpress-public-subnet"
	}		
}

# Create a private subnet

resource "aws_subnet" "wordpress_private_subnet" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = "10.0.2.0/24"

	tags = {
		Name = "wordpress-private-subnet"
	}
}

# Create a route table for the public subnet

resource "aws_route_table" "wordpress_public_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id

	tags = {
		Name = "wordpress-public-rt"
	}
}


# Associate the public subnet with the public route table

resource "aws_route_table_association" "wordpress_public_rt_assoc" {
  subnet_id      = aws_subnet.wordpress_public_subnet.id
  route_table_id = aws_route_table.wordpress_public_rt.id
}


# Create a route table for the private subnet

resource "aws_route_table" "wordpress_private_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id

	tags = {
		Name = "wordpress-private-rt"
	}
}


# Associate the private subnet with the private route table

resource "aws_route_table_association" "wordpress_private_rt_assoc" {
  subnet_id      = aws_subnet.wordpress_private_subnet.id
  route_table_id = aws_route_table.wordpress_private_rt.id
}




# Create an internet gateway

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id

	tags = {
		Name = "wordpress-igw"
  }
}


# Attach the internet gateway to the VPC

resource "aws_main_route_table_association" "wordpress_main_rt_assoc" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  route_table_id          = aws_vpc.wordpress_vpc.main_route_table_id
}

# Create a route for internet access via the internet gateway

resource "aws_route" "wordpress_public_route" {
  route_table_id            = aws_route_table.wordpress_public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.wordpress_igw.id
}





# Create a security group for the public subnet

resource "aws_security_group" "wordpress_public_sg" {
  vpc_id = aws_vpc.wordpress_vpc.id

  # Allow inbound SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
	tags = {
		Name = "wordpress-public-sg"
	}

}

# Create a security group for the private subnet

resource "aws_security_group" "wordpress_private_sg" {
  vpc_id = aws_vpc.wordpress_vpc.id

  # Allow inbound database access
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["12.0.1.0/24"]  # Update with the public subnet CIDR range
  }
	tags = {
		Name = "wordpress-private-sg"
	}

}




# Create an EC2 instance

resource "aws_instance" "wordpress_instance" {
  ami                    = "ami-0f8e81a3da6e2510a"  # Replace with your desired AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wordpress_public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_public_sg.id]
  key_name               = "North"  # Replace with the name of your key pair
  associate_public_ip_address = true  # Enable a public IP address for the instance

  tags = {
    Name = "wordpress"
  }
}







