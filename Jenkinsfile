pipeline {
    agent none
    environment {
        DOCKER_CONFIG = '/tmp/.docker'
        repoUrl = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app"
        repoRegistryUrl = "503499294473.dkr.ecr.us-east-1.amazonaws.com"
        registryCreds = 'ecr:us-east-1:awscreds'
        cluster = "simple-java-app"
        region = 'us-east-1'
    }

    stages {
        stage('Docker Test') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    sh 'docker ps'
                }
            }
        }
    }
}