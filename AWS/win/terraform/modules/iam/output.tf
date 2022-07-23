output "iam_instance_profile" {
    value = aws_iam_role.fme_server.name
    description = "IAM role for ec2 instances to join a AD"
}