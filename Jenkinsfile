pipeline {
    agent any

    environment {
        AWS_REGION    = "us-east-1"
        ECR_REPO      = "503499294473.dkr.ecr.${AWS_REGION}.amazonaws.com/simple-java-app"
        IMAGE_TAG     = "build-${BUILD_NUMBER}"   // unique tag per build
        TERRAFORM_DIR = "./terraform"            // path to your .tf configs
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']])
            }
        }
        /***
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_REPO}
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh """
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REPO}:latest
                    """
                }
            }
        } ***/

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                        terraform init -input=false
                        terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
                        """
                    }
                }
            }
        }
    }
}
