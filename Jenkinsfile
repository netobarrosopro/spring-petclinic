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
                    def devContainer = docker.image('spring-petclinic:latest').run('-d -p 8081:8080')
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
                    def prodContainer = docker.image('spring-petclinic:latest').run('-d -p 8082:8080')
                    sh "echo 'Prod Container ID: ${prodContainer.id}'"
                    sleep 10 // Aguarde um pouco para o container tentar iniciar
                    sh "docker logs ${prodContainer.id}"
                    // Caso precise copiar arquivos do container para o host, ajuste o caminho corretamente
                    // sh "docker cp ${prodContainer.id}:/app /path/to/production"
                }
            }
        }
    }
    // Remova ou comente a seção post para não limpar os containers e imagens após a execução
    // post {
    //     always {
    //         script {
    //             // Remover containers e imagens temporários
    //             sh 'docker ps -a -q | xargs -r docker rm || true'
    //             sh 'docker images -q spring-petclinic:latest | xargs -r docker rmi || true'
    //         }
    //     }
    // }
}
