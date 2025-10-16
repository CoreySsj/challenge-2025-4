# #!/bin/bash
# set -e
# # Variables de entorno
# # EKS_CLUSTER_NAME="mycluster"
# # ECR_BACKEND_REPO="usermgmt-marco"
# # ECR_FRONTEND_REPO="usermgmt-marco-frontend"
# # IMAGE_TAG=$(echo $CODEBUILD_BUILD_ID | cut -d: -f2 | cut -c 1-7)
# # BACKEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_BACKEND_REPO
# # FRONTEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_FRONTEND_REPO
# export EKS_CLUSTER_NAME="mycluster"
# export ECR_BACKEND_REPO="usermgmt-marco"
# export ECR_FRONTEND_REPO="usermgmt-marco-frontend"
# export IMAGE_TAG=$(echo $CODEBUILD_BUILD_ID | cut -d: -f2 | cut -c 1-7)
# export BACKEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_BACKEND_REPO
# export FRONTEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_FRONTEND_REPO

# # DEBUG: verificar que las variables estén definidas
# echo "DEBUG: AWS_ACCOUNT_ID_MARCO = '$AWS_ACCOUNT_ID_MARCO'"
# echo "DEBUG: AWS_REGION_MARCO = '$AWS_REGION_MARCO'"
# echo "DEBUG: BACKEND_URI = '$BACKEND_URI'"
# echo "DEBUG: FRONTEND_URI = '$FRONTEND_URI'"
# echo "DEBUG: IMAGE_TAG = '$IMAGE_TAG'"


# echo "DEBUG: comando docker build -t $BACKEND_URI:$IMAGE_TAG ./backend"
# docker build -t "$BACKEND_URI:$IMAGE_TAG" ./backend


# echo "Iniciando sesión en Amazon ECR..."
# aws ecr get-login-password --region $AWS_REGION_MARCO | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com

# echo "Configurando credenciales para el clúster de EKS $EKS_CLUSTER_NAME..."
# aws eks update-kubeconfig --region $AWS_REGION_MARCO --name $EKS_CLUSTER_NAME

pre_build:
  commands:
    - echo "Ejecutando pre-build..."
    - aws --version
    - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 711387135481.dkr.ecr.us-east-1.amazonaws.com
