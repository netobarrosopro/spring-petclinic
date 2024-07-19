pipeline {
    agent any
    environment {
        DOCKER_HOST = 'tcp://172.16.255.34:2376'
        REPO_URL = 'https://github.com/netobarrosopro/spring-petclinic.git'
    }
    stages {
        stage('Clone repository') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }
        stage('Build Project') {
            steps {
                script {
                    sh './mvnw clean package -DskipTests'
                }
            }
        }
        stage('Verify Build') {
            steps {
                script {
                    if (!fileExists('target/spring-petclinic-1.5.1.jar')) {
                        error "Build failed: JAR file not found"
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('spring-petclinic:latest', '.')
                }
            }
        }
        stage('Development') {
            steps {
                script {
                    docker.image('spring-petclinic:latest').run('-p 8080:8080')
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Aqui você pode adicionar os comandos de teste
                    sh 'echo "Running tests..."'
                }
            }
        }
        stage('Deploy to Production') {
            steps {
                script {
                    def container = docker.image('spring-petclinic:latest').run('-p 8080:8080')
                    sh 'docker cp ${container.id}:/app /path/to/production'
                }
            }
        }
    }
    post {
        always {
            script {
                // Remover containers e imagens temporários
                sh 'docker rm $(docker ps -a -q) || true'
                sh 'docker rmi spring-petclinic:latest || true'
            }
        }
    }
}
