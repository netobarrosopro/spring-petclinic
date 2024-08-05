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
                    // Parar os contêineres antigos do Spring Petclinic
                    sh 'docker ps -a -q --filter "name=spring-petclinic" | xargs -r docker stop || true'
                    sh 'docker ps -a -q --filter "name=spring-petclinic" | xargs -r docker rm -f || true'
                }
            }
        }
        stage('Start Database Containers') {
            steps {
                script {
                    // Verificar e iniciar contêineres de banco de dados, se necessário
                    def mysqlRunning = sh(script: 'docker ps -q --filter "name=mysql"', returnStdout: true).trim()
                    if (!mysqlRunning) {
                        sh 'docker-compose -f /path/to/your/docker-compose.yml up -d mysql'
                    }

                    def postgresRunning = sh(script: 'docker ps -q --filter "name=postgres"', returnStdout: true).trim()
                    if (!postgresRunning) {
                        sh 'docker-compose -f /path/to/your/docker-compose.yml up -d postgres'
                    }
                }
            }
        }  
        stage('Development') {
            steps {
                script {
                    echo "Usando a porta: 8081 para o ambiente de desenvolvimento"
                    def devContainer = docker.image('spring-petclinic:latest').run("-d -p 8081:8080 --name spring-petclinic-dev --restart unless-stopped")
                    sh "echo 'Dev Container ID: ${devContainer.id}'"
                    sleep 10 // Aguarde um pouco para o contêiner tentar iniciar
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
                    def prodContainer = docker.image('spring-petclinic:latest').run("-d -p 8080:8080 --name spring-petclinic-prod --restart unless-stopped")
                    sh "echo 'Prod Container ID: ${prodContainer.id}'"
                    sleep 10 // Aguarde um pouco para o contêiner tentar iniciar
                    sh "docker logs ${prodContainer.id}"
                }
            }
        }
    }
    post {
        always {
            script {
                // Preservar os contêineres antigos enquanto os novos são iniciados
                def oldContainers = sh(script: 'docker ps -a -q --filter "name=spring-petclinic"', returnStdout: true).trim().tokenize('\n')
                def newDevContainerId = sh(script: 'docker ps -q --filter "name=spring-petclinic-dev"', returnStdout: true).trim()
                def newProdContainerId = sh(script: 'docker ps -q --filter "name=spring-petclinic-prod"', returnStdout: true).trim()

                // Remover os contêineres antigos parados
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
