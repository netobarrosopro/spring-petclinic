pipeline {
    agent any
    environment {
        DOCKER_HOST = 'tcp://172.16.255.34:2376'
        REPO_URL = 'https://github.com/netobarrosopro/spring-petclinic.git'
    }
    stages {
        stage('Cleanup') {
            steps {
                script {
                    // Remover containers e imagens anteriores
                    sh 'docker ps -a -q --filter "name=spring-petclinic" | xargs -r docker rm -f || true'
                    sh 'docker images -q spring-petclinic:latest | xargs -r docker rmi || true'
                }
            }
        }
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
        stage('Development') {
            steps {
                script {
                    def port = new Random().nextInt(1000) + 8000
                    echo "Usando a porta: ${port} para o ambiente de desenvolvimento"
                    def devContainer = docker.image('spring-petclinic:latest').run("-d -p ${port}:8080 --name spring-petclinic-dev")
                    sh "echo 'Dev Container ID: ${devContainer.id}'"
                    sleep 10 // Aguarde um pouco para o container tentar iniciar
                    sh "docker logs ${devContainer.id}"
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
                    def port = new Random().nextInt(1000) + 8000
                    echo "Usando a porta: ${port} para o ambiente de produção"
                    def prodContainer = docker.image('spring-petclinic:latest').run("-d -p ${port}:8080 --name spring-petclinic-prod")
                    sh "echo 'Prod Container ID: ${prodContainer.id}'"
                    sleep 10 // Aguarde um pouco para o container tentar iniciar
                    sh "docker logs ${prodContainer.id}"
                }
            }
        }
    }
  //post {
  //    always {
  //        script {
  //            // Remover containers temporários
  //            sh 'docker ps -a -q --filter "name=spring-petclinic" | xargs -r docker rm -f || true'
  //            // Remover imagens temporárias
  //            sh 'docker images -q spring-petclinic:latest | xargs -r docker rmi || true'
  //        }
  //    }
  //}
}
