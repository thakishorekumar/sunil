#Fetching Specific AMI from Source Region(Mumbai) and Copy AMI and deploy Instance in DR Region(Hyderabad)

data "aws_ami" "source_ami_data" {
  provider = aws.primary
  owners   = ["self"]

  filter {
    name   = "name"
    values = ["Web_Node_Mumbai"]
  }
}

output "source_ami" {
  value = data.aws_ami.source_ami_data[*]
}

resource "aws_ami_copy" "source_ami_copy" {
  provider          = aws.secondary
  name              = "terraform-copy"
  description       = "A copy of ami"
  source_ami_id     = data.aws_ami.source_ami_data.id
  source_ami_region = "ap-south-1"

  tags = {
    Name = "Terraform-DR-AMI"
  }
}

resource "aws_instance" "DR_instance" {
  provider               = aws.secondary
  ami                    = aws_ami_copy.source_ami_copy.id
  instance_type          = "t3.micro"
  key_name               = "Hyderabad-Biryani"
  subnet_id              = aws_subnet.dr-pub-sub-1a.id
  vpc_security_group_ids = [aws_security_group.dr-sg.id] # Replace with the correct security group in the destination account

  user_data = base64encode(<<-EOF
    <powershell>
    # Path to the app.js file
    $appJsPath = "C:\Users\Administrator\Desktop\Node\app.js"

    # Old and new host values
    $oldHost = "database-1.cdqicm2cap2j.ap-south-1.rds.amazonaws.com"
    $newHost = "secondary-db.c5uykkeaygl0.ap-south-2.rds.amazonaws.com"

    # Read the content of the file
    $fileContent = Get-Content -Path $appJsPath

    # Replace the old host value with the new one
    $updatedContent = $fileContent -replace $oldHost, $newHost

    # Write the updated content back to the file
    Set-Content -Path $appJsPath -Value $updatedContent
    </powershell>
  EOF
  )

  tags = {
    Name = "DR-Instance"
  }
}
