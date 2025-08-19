pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '503499294473.dkr.ecr.us-east-1.amazonaws.com/jenkinz-pipeline-build'
        IMAGE_NAME = 'jenkinz-pipeline-build'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CACHE_TAG = "latest"
    }
    
    tools {
        maven 'Maven3'  
    }
    
    stages {
        
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kingsleychino/simple-java-app.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Package') {
            steps {
                sh 'mvn package'
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

        stage('Pull Previous Image for Caching') {
            steps {
                script {
                    sh '''
                    docker pull ${ECR_REPO}:${CACHE_TAG} || echo "No cache image found, building fresh."
                    '''
                }
            }
        }

        stage('Build Docker Image with Cache') {
            steps {
                script {
                    def localTag = "${IMAGE_NAME}:${IMAGE_TAG}"
                    def cacheFrom = "${ECR_REPO}:${CACHE_TAG}"
                    def image = docker.build(localTag, "--cache-from=${cacheFrom} .")
                }
            }
        }
        
        stage('Tag & Push to ECR') {
            steps {
                script {
                    def localTag = "${IMAGE_NAME}:${IMAGE_TAG}"
                    def buildTag = "${ECR_REPO}:${IMAGE_TAG}"
                    def latestTag = "${ECR_REPO}:${CACHE_TAG}"
                    sh '''
                    docker tag ${localTag} ${buildTag}
                    docker tag ${localTag} ${latestTag}
                    docker push ${buildTag}
                    docker push ${latestTag}
                    '''
                }
            }
        }
        
    }
    
    post {
        success {
            echo '✅ Build completed successfully!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}