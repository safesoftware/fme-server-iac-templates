resource "aws_iam_instance_profile" "fme_server" {
  name = "fmeServerEC2JoinAD"
  role = aws_iam_role.fme_server.name
}
resource "aws_iam_role" "fme_server" {
  name = "EC2JoinAD"

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

  inline_policy {
    name = "AmazonEC2RoleforSSM-ASGDomainJoin"
    
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ssm:DescribeAssociation",
                  "ssm:GetDeployablePatchSnapshotForInstance",
                  "ssm:GetDocument",
                  "ssm:DescribeDocument",
                  "ssm:GetManifest",
                  "ssm:GetParameters",
                  "ssm:ListAssociations",
                  "ssm:ListInstanceAssociations",
                  "ssm:PutInventory",
                  "ssm:PutComplianceItems",
                  "ssm:PutConfigurePackageResult",
                  "ssm:UpdateAssociationStatus",
                  "ssm:UpdateInstanceAssociationStatus",
                  "ssm:UpdateInstanceInformation",
                  "ssm:CreateAssociation"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ssmmessages:CreateControlChannel",
                  "ssmmessages:CreateDataChannel",
                  "ssmmessages:OpenControlChannel",
                  "ssmmessages:OpenDataChannel"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ec2messages:AcknowledgeMessage",
                  "ec2messages:DeleteMessage",
                  "ec2messages:FailMessage",
                  "ec2messages:GetEndpoint",
                  "ec2messages:GetMessages",
                  "ec2messages:SendReply"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "cloudwatch:PutMetricData"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ec2:DescribeInstanceStatus"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ds:CreateComputer",
                  "ds:DescribeDirectories"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:DescribeLogGroups",
                  "logs:DescribeLogStreams",
                  "logs:PutLogEvents"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "s3:GetBucketLocation",
                  "s3:PutObject",
                  "s3:GetObject",
                  "s3:GetEncryptionConfiguration",
                  "s3:AbortMultipartUpload",
                  "s3:ListMultipartUploadParts",
                  "s3:ListBucket",
                  "s3:ListBucketMultipartUploads"
              ],
              "Resource": "*"
          }
      ]
    })
    
  }

  tags = {
    "Description" = "IAM role for ec2 instances to join a AD"
  }
}