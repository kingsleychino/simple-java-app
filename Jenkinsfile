pipeline {
    agent any
    
    tools {
        maven 'Maven3'  
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }
    
    stages{
        
        stage('Build maven') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']])
                sh 'mvn clean install'
            }
        }

        stage('Build docker image') {
            steps {
                script {
                    sh 'docker build -t simple-java-app .'
                }
            }
        }

        stage('Push image to ECR') {
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/a4g8l0d7'
                sh 'docker tag simple-java-app:latest public.ecr.aws/a4g8l0d7/simple-java-app:latest'
                sh 'docker push public.ecr.aws/a4g8l0d7/simple-java-app:latest'
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
