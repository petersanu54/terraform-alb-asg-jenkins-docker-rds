#####################iam instance profile#############################
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "ubuntu_iam_instance_profile"
  role = aws_iam_role.iam_role.name
  tags = {
    "Name" = "ubuntu_iam_instance_profile"
  }
}

####################iam instance role#################################
resource "aws_iam_role" "iam_role" {
  name = "ubuntu_iam_role"
  path = "/"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

####################iam policy########################################
resource "aws_iam_role_policy" "iam_role_policy" {
  name = "ubuntu_iam_role_policy"
  role = aws_iam_role.iam_role.name

  policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow"
        "Resource": "*"
      }
    ]
    })

}


output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.iam_instance_profile.name
}

