pipeline {
    agent any

    tools {
        maven 'Maven-3'
    }

    stages {
        stage('Build Maven') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']])
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t simple-java-app .'
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 503499294473.dkr.ecr.us-east-1.amazonaws.com
                    docker tag simple-java-app:latest 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:latest
                    docker push 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:latest
                '''
            }
        }
    }
}
