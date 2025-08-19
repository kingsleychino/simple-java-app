pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '503499294473.dkr.ecr.us-east-1.amazonaws.com/jenkinz-pipeline-build'
        IMAGE_NAME = 'jenkinz-pipeline-build'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Login to AWS ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ECR_REPO
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        stage('Tag & Push to ECR') {
            steps {
                script {
                    def localTag = "${IMAGE_NAME}:${IMAGE_TAG}"
                    def remoteTag = "${ECR_REPO}:${IMAGE_TAG}"
                    sh "docker tag ${localTag} ${remoteTag}"
                    sh "docker push ${remoteTag}"
                }
            }
        }
    }
    post {
        success {
            echo "✅ Docker Image pushed: $ECR_REPO:$IMAGE_TAG"
        }
        failure {
            echo "❌ Build failed. Please check the logs."
        }
    }
}