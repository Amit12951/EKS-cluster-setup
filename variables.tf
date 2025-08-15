# In this YAML we defined two separate deployments of Nginx:
# One for x86 instances (amd64 architecture) and another for ARM64 instances (Graviton architecture).
# In this case, Karpenter will manage the scaling of both instances based on demand, and the node selector ensures the right architecture is used.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-x86-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-x86
  template:
    metadata:
      labels:
        app: nginx-x86
    spec:
      nodeSelector:
        beta.kubernetes.io/arch: "amd64"  # This ensures Nginx is deployed on x86 (Intel/AMD) instances.
      containers:
        - name: nginx
          image: nginx:latest  # Deploying Nginx on x86 instance type.
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-arm64-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-arm64
  template:
    metadata:
      labels:
        app: nginx-arm64
    spec:
      nodeSelector:
        beta.kubernetes.io/arch: "arm64"  # This ensures Nginx is deployed on ARM64 (Graviton) instances.
      containers:
        - name: nginx
          image: nginx:latest  # Deploying Nginx on ARM64 (Graviton) instance type.
