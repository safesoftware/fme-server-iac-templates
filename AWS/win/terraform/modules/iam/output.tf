output "iam_instance_profile" {
    value = aws_iam_instance_profile.fme_server.name
    description = "IAM role for ec2 instances to join a AD"
}