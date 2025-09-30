pipeline {
    agent any

    environment {
        AWS_REGION    = "us-east-1"
        ECR_REPO      = "503499294473.dkr.ecr.${AWS_REGION}.amazonaws.com/simple-java-app"
        IMAGE_TAG     = "build-${BUILD_NUMBER}"     // unique image tag for each build
        TERRAFORM_DIR = "./terraform"              // path to your .tf files
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    echo '🔨 Building Docker image...'
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
                    echo '🔑 Logging into Amazon ECR...'
                    aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_REPO}
                    """
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    sh """
                    echo '📤 Pushing image to ECR...'
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                        echo '📦 Initializing Terraform...'
                        terraform init -input=false
                        """
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                        echo '🚀 Applying Terraform configuration...'
                        terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
                        """
                    }
                }
            }
        }

        stage('Terraform Destroy (Optional)') {
            when {
                expression { return params.DESTROY_INFRA == true }  // Only run if checkbox selected
            }
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                        echo '💣 Destroying Terraform resources...'
                        terraform destroy -auto-approve -var="image_tag=${IMAGE_TAG}"
                        """
                    }
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure after deployment')
    }

    post {
        always {
            echo '✅ Pipeline finished.'
        }
    }
}
