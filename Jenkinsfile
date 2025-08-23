pipeline {
    agent any
    
    tools {
        maven 'Maven3'  
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
                    sh 'docker build -t simple-java-app-private .'
                }
            }
        }

        stage('Push image to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 503499294473.dkr.ecr.us-east-1.amazonaws.com
                    docker tag simple-java-app-private:latest 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app-private:latest
                    docker push 503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app-private:latest
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
