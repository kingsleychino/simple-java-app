pipeline {
    agent any
    
    tools {
        maven 'Maven3'  
    }
    
    stages{
        
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kingsleychino/simple-java-app.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean install'
                sh 'printenv'
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

        stage('Publish ECR') {
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/a4g8l0d7'
                sh 'docker build -t ecr-demoing .'
                sh 'docker tag ecr-demoing:latest public.ecr.aws/a4g8l0d7/ecr-demoing:””$BUILD_ID""'
                sh 'docker push public.ecr.aws/a4g8l0d7/ecr-demoing:""$BUILD_ID""'
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
