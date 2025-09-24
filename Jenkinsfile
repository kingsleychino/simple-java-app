pipeline {
    agent any

    environment {
        DOCKER_ADDRESS = "503499294473.dkr.ecr.us-east-1.amazonaws.com"
        DOCKER_IMAGE   = "java-app"
        VERSION        = "v1.${BUILD_NUMBER}"
    }

    tools {
        maven 'Maven-3'
    }

    stages {
        stage('Build Maven') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']]
                )
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${VERSION} ."
                }
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_ADDRESS}
                    docker tag ${DOCKER_IMAGE}:${VERSION} ${DOCKER_ADDRESS}/${DOCKER_IMAGE}:${VERSION}
                    docker push ${DOCKER_ADDRESS}/${DOCKER_IMAGE}:${VERSION}
                """
            }
        }
    }
}
