# AWS EKS Cluster with Karpenter (Graviton & Spot Instances)

## Overview
This repository contains Terraform scripts to deploy an EKS cluster with Karpenter autoscaling. The cluster is configured to utilize both x86 and Graviton (ARM64) instances, with Spot instances used to optimize cost.

## Prerequisites
- AWS CLI installed and configured
- Terraform installed
- Helm installed 

# from inside the repo folder run tf init > tf apply