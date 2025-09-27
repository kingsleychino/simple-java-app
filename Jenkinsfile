pipeline {
    agent any

    environment {
        DOCKER_ADDRESS = "503499294473.dkr.ecr.us-east-1.amazonaws.com"
        DOCKER_IMAGE   = "simple-java-app"
        VERSION        = "v1.${BUILD_NUMBER}"
        FULL_IMAGE     = "${DOCKER_ADDRESS}/${DOCKER_IMAGE}:${VERSION}"
    }

    tools {
        maven 'Maven-3'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/kingsleychino/simple-java-app'
                    ]]
                )
            }
        }
        
        // stage('Build Maven') {
        //     steps {
        //         sh 'mvn clean install'
        //     }
        // }

        // stage('Build Docker Image') {
        //     steps {
        //         sh "docker build -t ${DOCKER_IMAGE}:${VERSION} ."
        //     }
        // }

        // stage('Tag & Push to ECR') {
        //     steps {
        //         sh """
        //             aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_ADDRESS}
        //             docker tag ${DOCKER_IMAGE}:${VERSION} ${FULL_IMAGE}
        //             docker push ${FULL_IMAGE}
        //         """
        //     }
        // }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    set -e
                    set -x
                    
                    aws ecs update-service \
                      --cluster ecs-fargate-cluster \
                      --service java-app-service \
                      --force-new-deployment \
                      --region us-east-1
                '''
            }
        }
    }
}
