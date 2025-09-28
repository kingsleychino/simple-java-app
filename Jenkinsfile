pipeline {
    agent any
    //agent { label 'docker terraform' }  // ✅ runs on your dedicated agent

    environment {
        AWS_REGION    = "us-east-1"
        ECR_REPO      = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app"
        TERRAFORM_DIR = "/var/lib/jenkins/workspace/simple-java-pipeline/terraform"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kingsleychino/simple-java-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "build-${env.BUILD_NUMBER}"
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        docker build -t $ECR_REPO:$IMAGE_TAG .
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh "docker push $ECR_REPO:$IMAGE_TAG"
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh """
                        terraform init -input=false
                        terraform apply -auto-approve \
                            -var="image_tag=$IMAGE_TAG" \
                            -var="ecr_repo_url=$ECR_REPO"
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()   // ✅ deletes workspace after every build
        }
    }
}

