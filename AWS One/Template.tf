resource "aws_launch_template" "web-template" {
  provider = aws.primary
  name     = "DR-Terraform-Template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 30
    }
  }

  disable_api_stop        = false
  disable_api_termination = false

  image_id = "ami-013767406719cc9f3"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  key_name = "Terraform-KeyPair"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web-sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Terraform-Template"
    }
  }

  user_data = base64encode(<<-EOF
    <powershell>
    # Path to the app.js file
    $appJsPath = "C:\Users\Administrator\Desktop\Node\app.js"

    # Old and new host values
    $oldHost = "secondary-db.c5uykkeaygl0.ap-south-2.rds.amazonaws.com"
    $newHost = "second-db.c5uykkeaygl0.ap-south-2.rds.amazonaws.com"

    # Read the content of the file
    $fileContent = Get-Content -Path $appJsPath

    # Replace the old host value with the new one
    $updatedContent = $fileContent -replace $oldHost, $newHost

    # Write the updated content back to the file
    Set-Content -Path $appJsPath -Value $updatedContent
    </powershell>
  EOF
  )
}


