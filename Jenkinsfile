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
                    sh 'docker ps -a -q --filter "name=spring-petclinic" | xargs -r docker stop || true'
                }
            }
        }
        stage('Development') {
            steps {
                script {
                    echo "Usando a porta: 8081 para o ambiente de desenvolvimento"
                    // Remover container antigo, se existir
                    sh 'docker ps -a -q --filter "name=spring-petclinic-dev" | xargs -r docker rm -f || true'
                    def devContainer = docker.image('spring-petclinic:latest').run("-d -p 8081:8080 --name spring-petclinic-dev --restart unless-stopped")
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
                    echo "Usando a porta: 8080 para o ambiente de produção"
                    // Remover container antigo, se existir
                    sh 'docker ps -a -q --filter "name=spring-petclinic-prod" | xargs -r docker rm -f || true'
                    def prodContainer = docker.image('spring-petclinic:latest').run("-d -p 8080:8080 --name spring-petclinic-prod --restart unless-stopped")
                    sh "echo 'Prod Container ID: ${prodContainer.id}'"
                    sleep 10 // Aguarde um pouco para o container tentar iniciar
                    sh "docker logs ${prodContainer.id}"
                }
            }
        }
    }
    post {
        always {
            script {
                // Preservar os containers antigos enquanto os novos são iniciados
                def oldContainers = sh(script: 'docker ps -a -q --filter "name=spring-petclinic"', returnStdout: true).trim().tokenize('\n')
                def newDevContainerId = sh(script: 'docker ps -q --filter "name=spring-petclinic-dev"', returnStdout: true).trim()
                def newProdContainerId = sh(script: 'docker ps -q --filter "name=spring-petclinic-prod"', returnStdout: true).trim()

                // Remover os containers antigos parados 
                oldContainers.each { containerId ->
                    if (containerId != newDevContainerId && containerId != newProdContainerId) {
                        sh "docker rm -f ${containerId}"
                    }
                }

                // Remover imagens temporárias  
                sh 'docker images -q spring-petclinic:latest | xargs -r docker rmi || true'
            }
        }
    }
}
