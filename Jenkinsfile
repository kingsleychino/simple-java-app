pipeline {
    agent any

    environment {
        AWS_REGION    = "us-east-1"
        ECR_REPO      = "503499294473.dkr.ecr.${AWS_REGION}.amazonaws.com/simple-java-app"
        IMAGE_TAG     = "build-${BUILD_NUMBER}"   // unique tag per build
        TERRAFORM_DIR = "./terraform"            // path to your .tf directory
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    echo "🔨 Building Docker image..."
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
                    echo "🔐 Logging in to ECR..."
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh """
                    echo "📤 Pushing Docker image to ECR..."
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
                        echo "⚙️ Initializing Terraform..."
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
                        echo "🚀 Applying Terraform deployment..."
                        terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
                        """
                    }
                }
            }
        }

        stage('Verify Deployment (Optional)') {
            steps {
                script {
                    echo "✅ Deployment complete! ECS service should now be running with ${IMAGE_TAG}"
                }
            }
        }

        stage('Terraform Destroy (Manual)') {
            when {
                expression { return params.DESTROY == true } // only if triggered manually
            }
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                        echo "🔥 Destroying infrastructure..."
                        terraform destroy -auto-approve -var="image_tag=${IMAGE_TAG}"
                        """
                    }
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Check this to destroy infrastructure after deploy')
    }

    post {
        always {
            echo "🏁 Pipeline finished."
        }
    }
}
