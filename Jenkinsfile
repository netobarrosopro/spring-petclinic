pipeline {
    agent any
    triggers {
        githubPush()
    }
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
                    if (!fileExists('target/spring-petclinic-3.3.0-SNAPSHOT.jar')) {
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
        stage('Stop Old Containers') {
            steps {
                script {
                    // Parar os containers antigos
                    sh 'docker-compose -f docker-compose.yml down || true'
                }
            }
        }
        stage('Development') {
            steps {
                script {
                    echo "Usando a porta: 8081 para o ambiente de desenvolvimento"
                    // Substituir a imagem e iniciar contêineres com Docker Compose
                    sh 'docker-compose -f docker-compose.dev.yml up -d'
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
                    echo "Usando a porta: 8080 para o ambiente de produção"
                    // Substituir a imagem e iniciar contêineres com Docker Compose
                    sh 'docker-compose -f docker-compose.prod.yml up -d'
                }
            }
        }
    }
    post {
        always {
            script {
                // Limpar imagens antigas não utilizadas
                sh 'docker image prune -f'
            }
        }
    }
}
