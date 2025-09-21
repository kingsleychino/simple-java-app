pipeline {
    agent any

    tools {
        maven 'Maven-3'
    }

    stages {
        stage('Build Maven') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kingsleychino/simple-java-app']])
                sh 'maven clean install'
            }
        }
    }
}
