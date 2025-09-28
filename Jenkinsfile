pipeline {
    agent any

    environment {
        AWS_REGION   = "us-east-1"
        ECR_REPO     = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app"
        APP_NAME     = "simple-java-app"
        TF_DIR       = "."
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kingsleychino/simple-java-app.git'
            }
        }

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $ECR_REPO:latest ."
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                docker push $ECR_REPO:latest
                """
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh "terraform init -input=false"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh "terraform apply -auto-approve -input=false"
                }
            }
        }

        stage('Terraform Destroy (Optional)') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                dir("${TF_DIR}") {
                    sh "terraform destroy -auto-approve -input=false"
                }
            }
        }
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure instead of applying')
    }

    post {
        always {
            cleanWs()   // ✅ deletes workspace after every build
        }
    }
}
