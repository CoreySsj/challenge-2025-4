#!/bin/bash

# Variables de entorno
export EKS_CLUSTER_NAME="mycluster"
export ECR_BACKEND_REPO="usermgmt-marco"
export ECR_FRONTEND_REPO="usermgmt-marco-frontend"
export K8S_BACKEND_DEPLOYMENT="usermgmt-service"
export K8S_FRONTEND_DEPLOYMENT="frontend"
export K8S_BACKEND_CONTAINER_NAME="usermgmt"
export K8S_FRONTEND_CONTAINER_NAME="frontend"
export IMAGE_TAG=$(echo $CODEBUILD_BUILD_ID | cut -d: -f2 | cut -c 1-7)
export BACKEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_BACKEND_REPO
export FRONTEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_FRONTEND_REPO

echo "Iniciando sesión en Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION_MARCO | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com

echo "Configurando credenciales para el clúster de EKS $EKS_CLUSTER_NAME..."
aws eks update-kubeconfig --region $AWS_REGION_MARCO --name $EKS_CLUSTER_NAME
