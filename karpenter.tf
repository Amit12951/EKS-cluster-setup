# Here we install Karpenter via Helm + its IAM role and policies

resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/karpenter"
  chart      = "karpenter"
  version    = "v0.36.0"

  namespace = "karpenter"
  create_namespace = true

  values = [
    jsonencode({
      controller = {
        clusterName = var.cluster_name
        clusterEndpoint = module.eks.cluster_endpoint
        aws = {
          defaultInstanceProfile = module.eks.eks_managed_node_groups["default"].iam_instance_profile_arn
        }
      }
    })
  ]
}

# IAM Role for the EC2 instances Karpenter will launch
resource "aws_iam_role" "karpenter_node" {
  name = "KarpenterNodeRole"

  # Allows EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach EKS Worker Node permissions to the role
resource "aws_iam_role_policy_attachment" "karpenter_ec2_policy" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach networking (CNI) permissions to the role
resource "aws_iam_role_policy_attachment" "karpenter_cni_policy" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}
