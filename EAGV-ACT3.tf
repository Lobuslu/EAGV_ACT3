provider "aws" {
    region = "us-east-1"
}

#VPC
resource "aws_vpc" "VPC_ACT3" {
    cidr_block = "10.10.0.0/20"
    tags = {
        Name = "VPC_ACT3"
    }
}

#subned publica
resource "aws_subnet" "subnet_publica" {
    vpc_id = aws_vpc.VPC_ACT3.id
    cidr_block = "10.10.0.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "subnet_publica"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC_ACT3.id
    tags = {
        Name = "IGW_ACT3"
    }
}

#Tabla de rutas
resource "aws_route_table" "tabla_rutas_publica" {
    vpc_id = aws_vpc.VPC_ACT3.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }

    tags = {
        Name = "tabla_rutas_publica"
    }
}

#Asociacion de la tabla de rutas
resource "aws_route_table_association" "asociacion_rutas_publica" {
    subnet_id = aws_subnet.subnet_publica.id
    route_table_id = aws_route_table.tabla_rutas_publica.id
}

#Grupo de seguiridad para Linux JUMP Server
resource "aws_security_group" "sg_jump_server" {
    name= "sg_jump_server"
    description= "Grupo de seguridad para Linux JUMP Server"
    vpc_id= aws_vpc.VPC_ACT3.id
    
    ingress {
        from_port= 22
        to_port= 22
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port= 22
        to_port= 22
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }

}

#Grupo de seguridad para Linux Web Server
resource "aws_security_group" "sg_web_server" {
    name= "sg_web_server"
    description= "Grupo de seguridad para Linux Web Server"
    vpc_id= aws_vpc.VPC_ACT3.id 

    ingress {
        from_port= 22
        to_port= 22
        protocol= "tcp"
        cidr_blocks= ["0.0.0.0/0"]
    }

    ingress {
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }

    egress {
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }

    egress {
        from_port= 80
        to_port= 80
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#Intancia de Linux JUMP Server
resource "aws_instance" "jump_server" {
    ami= "ami-00a929b66ed6e0de6"
    instance_type= "t2.medium"
    subnet_id= aws_subnet.subnet_publica.id
    vpc_security_group_ids= [aws_security_group.sg_jump_server.id]
    key_name= "vockey"
    tags = {
        Name = "Linux-Jump-Server"
    }
}

#Intancia de Linux Web Server
resource "aws_instance" "web_server" {
    ami= "ami-00a929b66ed6e0de6"
    instance_type= "t2.micro"
    subnet_id= aws_subnet.subnet_publica.id
    vpc_security_group_ids= [aws_security_group.sg_web_server.id]
    key_name= "vockey"
    tags = {
        Name = "Linux-Web-Server"
    }
}

#Intancia de Linux Web Server2
resource "aws_instance" "web_server2" {
    ami= "ami-00a929b66ed6e0de6"
    instance_type= "t2.micro"
    subnet_id= aws_subnet.subnet_publica.id
    vpc_security_group_ids= [aws_security_group.sg_web_server.id]
    key_name= "vockey"
    tags = {
        Name = "Linux-Web-Server"
    }
}

#Intancia de Linux Web Server3
resource "aws_instance" "web_server3" {
    ami= "ami-00a929b66ed6e0de6"
    instance_type= "t2.micro"
    subnet_id= aws_subnet.subnet_publica.id
    vpc_security_group_ids= [aws_security_group.sg_web_server.id]
    key_name= "vockey"
    tags = {
        Name = "Linux-Web-Server"
    }
}

#Intancia de Linux Web Server4
resource "aws_instance" "web_server4" {
    ami= "ami-00a929b66ed6e0de6"
    instance_type= "t2.micro"
    subnet_id= aws_subnet.subnet_publica.id
    vpc_security_group_ids= [aws_security_group.sg_web_server.id]
    key_name= "vockey"
    tags = {
        Name = "Linux-Web-Server"
    }
}

#output de IPs publicas
output "ip_publica" {
    value = aws_instance.jump_server.public_ip
    description = "IP publica del Linux Jump Server"
}
output "ip_publica_web_server" {
    value = aws_instance.web_server.public_ip
    description = "IP publica del Linux Web Server"
}
output "ip_publica_web_server2" {
    value = aws_instance.web_server2.public_ip
    description = "IP publica del Linux Web Server2"
}
output "ip_publica_web_server3" {
    value = aws_instance.web_server3.public_ip
    description = "IP publica del Linux Web Server3"
}
output "ip_publica_web_server4" {
    value = aws_instance.web_server4.public_ip
    description = "IP publica del Linux Web Server4"
}
