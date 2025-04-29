pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'Sonar-Scanner'    
        App_Name = 'online-shop'
        RELEASE = '1.0.0'
        DOCKER_USER = 'DockerHub-Creds'
        DOCKER_PASS = 'DockerHub-Creds'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        

    }

    stages {
        stage('Code Checkout') {
            steps {
                git branch: 'feature/feature-branch-1', changelog: false, poll: false, url: 'https://github.com/isthatyous/Hackathon-Phase-1.git'
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh """$SCANNER_HOME/bin/sonar-scanner \
                          -Dsonar.projectName=online-shop \
                          -Dsonar.projectKey=online-shop \
                    """
                }
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    sh "Building Docker Image"
                    docker.withRegistry('',DOCKER_PASS) {
                         docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry('',DOCKER_PASS) {
                         docker_image.push("${IMAGE_TAG}")
                         docker_image.push('latest')
                    }
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub-Creds', usernameVariable: 'DockerHubusername', passwordVariable: 'DockerHubpassword')]) {
                    sh "trivy image ${DockerHubusername}/${image_name}:${env.BUILD_ID}"
                }
            }
        }

      
            }
        }
    
}
