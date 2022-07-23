resource "aws_iam_role" "fme_server" {
  name = "fmeServerEC2JoinAD"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"]

  tags = {
    "Description" = "IAM role for ec2 instances to join a AD"
  }
}