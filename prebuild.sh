#!/bin/bash
set -e  # Salir si hay algún error

# Variables de entorno
export EKS_CLUSTER_NAME="mycluster"
export ECR_BACKEND_REPO="usermgmt-marco"
export ECR_FRONTEND_REPO="usermgmt-marco-frontend"
export IMAGE_TAG=$(echo $CODEBUILD_BUILD_ID | cut -d: -f2 | cut -c 1-7)
export BACKEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_BACKEND_REPO
export FRONTEND_URI=$AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com/$ECR_FRONTEND_REPO

# DEBUG: verificar variables
echo "DEBUG: AWS_ACCOUNT_ID_MARCO = '$AWS_ACCOUNT_ID_MARCO'"
echo "DEBUG: AWS_REGION_MARCO = '$AWS_REGION_MARCO'"
echo "DEBUG: BACKEND_URI = '$BACKEND_URI'"
echo "DEBUG: FRONTEND_URI = '$FRONTEND_URI'"
echo "DEBUG: IMAGE_TAG = '$IMAGE_TAG'"

# --- 1️⃣ Compilar Backend ---
echo "Compilando backend..."
cd backend
mvn clean package -DskipTests
cd ..

# --- 2️⃣ Compilar Frontend ---
echo "Compilando frontend..."
cd frontend
npm install
npm run build
cd ..

# --- 3️⃣ Construir imágenes Docker ---
echo "Construyendo imagen Docker del backend..."
docker build -t "$BACKEND_URI:$IMAGE_TAG" ./backend

echo "Construyendo imagen Docker del frontend..."
docker build -t "$FRONTEND_URI:$IMAGE_TAG" ./frontend

# --- 4️⃣ Login a ECR ---
echo "Iniciando sesión en Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION_MARCO | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID_MARCO.dkr.ecr.$AWS_REGION_MARCO.amazonaws.com

# --- 5️⃣ Subir imágenes a ECR ---
echo "Subiendo imagen backend a ECR..."
docker push "$BACKEND_URI:$IMAGE_TAG"

echo "Subiendo imagen frontend a ECR..."
docker push "$FRONTEND_URI:$IMAGE_TAG"

# --- 6️⃣ Configurar kubeconfig para EKS ---
echo "Configurando credenciales para el clúster de EKS $EKS_CLUSTER_NAME..."
aws eks update-kubeconfig --region $AWS_REGION_MARCO --name $EKS_CLUSTER_NAME
