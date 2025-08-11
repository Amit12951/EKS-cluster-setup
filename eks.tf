# This file sets up the EKS cluster and the necessary IAM role to allow EKS to interact with AWS resources.
# in addition, provisions the Kubernetes cluster and configures it to use the subnets defined in the VPC.

resource "aws_eks_cluster" "main" {
  name = "eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet.id,
      aws_subnet.private_subnet.id
    ]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
