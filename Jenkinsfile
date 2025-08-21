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

        stage('Publish ECR') {
            steps {
                withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRETE_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]) {
                    sh 'docker login -u aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 503499294473.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker build -t simple-java-app .'
                    sh 'docker tag simple-java-app:""$BUILD_ID""'
                    sh 'docker push 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:""BUILD_ID""'
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