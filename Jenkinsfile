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

        sstage('ECR Login') {
            steps {
                sh '''
                  aws ecr get-login-password --region us-east-1 \
                  | docker login --username AWS --password-stdin 503499294473.dkr.ecr.us-east-1.amazonaws.com
                '''
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                sh '''
                  docker build -t simple-java-app .
                  docker tag simple-java-app:latest 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:latest
                  docker push 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:latest
                '''
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