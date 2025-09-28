pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO   = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app"
        APP_NAME   = "simple-java-app"
        TF_DIR     = "terraform"
        IMAGE_TAG  = "build-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kingsleychino/simple-java-app.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t $ECR_REPO:${IMAGE_TAG} ."
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                docker push $ECR_REPO:${IMAGE_TAG}
                """
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh "terraform init -input=false"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.DESTROY == false }
            }
            steps {
                dir("${TF_DIR}") {
                    sh """
                    terraform apply -auto-approve -input=false \
                        -var=image_tag=${IMAGE_TAG} \
                        -var=ecr_repo_url=${ECR_REPO} \
                        -var=region=${AWS_REGION}
                    """
                }
            }
        }

        stage('Terraform Destroy (Optional)') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                input message: "Are you sure you want to destroy all infrastructure?", ok: "Yes, destroy"
                dir("${TF_DIR}") {
                    sh """
                    terraform destroy -auto-approve -input=false \
                        -var=image_tag=${IMAGE_TAG} \
                        -var=ecr_repo_url=${ECR_REPO} \
                        -var=region=${AWS_REGION}
                    """
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure instead of applying')
    }

    post {
        always {
            cleanWs()
        }
    }
}
