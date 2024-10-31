resource "aws_launch_template" "bastion" {
  name_prefix   = "${var.project_name}-bastion-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.bastion_sg.id]  
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-bastion"
    }
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                     = "${var.project_name}-bastion-asg"
  vpc_zone_identifier      = var.subnet_ids
  desired_capacity         = var.desired_capacity
  min_size                 = var.min_size
  max_size                 = var.max_size
  health_check_type        = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.bastion.id
    version = aws_launch_template.bastion.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-bastion"
    propagate_at_launch = true
  }
}

resource "aws_key_pair" "bastion_keys" {
  key_name   = var.key_name
  public_key = var.public_keys
  lifecycle {
    ignore_changes = [public_key]
  }
}