# EKS Cluster with Karpenter, Graviton & Spot Instances

## Overview
This repository creates an AWS EKS cluster using Terraform. It also installs Karpenter for dynamic node autoscaling with support for both x86_64 and Graviton (arm64) instance types, including Spot instances for cost efficiency.

## Features
- EKS cluster 
- Karpenter installed via Helm
- VPC with public/private subnets
- Mixed architecture support: x86 and Graviton (arm64)
- Spot instance utilization for cost saving


## For deploying this infra please follow the instactions below - 

# Initialize Terraform
terraform init

# Apply the infrastructure
terraform apply

# Update kubeconfig
aws eks update-kubeconfig --name MyEKSCluster --region us-east-1

# Verify cluster access
kubectl get nodes


## Testing: Schedule Pod on x86 vs Graviton using nodeSelector
To test a pod on a specific architecture:

### x86_64 Example -

apiVersion: v1
kind: Pod
metadata:
  name: x86-pod
spec:
  nodeSelector:
    kubernetes.io/arch: amd64
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]


### arm64 (Graviton) Example -

apiVersion: v1
kind: Pod
metadata:
  name: arm64-pod
spec:
  nodeSelector:
    kubernetes.io/arch: arm64
  containers:
  - name: busybox
    image: public.ecr.aws/bitnami/busybox:latest
    command: ["sleep", "3600"]

## Cleanup
terraform destroy -auto-approve

## Create Karpenter NodePool

After the cluster is ready and Karpenter is deployed, apply the following command to allow provisioning of Spot instances across both architectures.

kubectl apply -f manifests/karpenter-nodepool.yaml
