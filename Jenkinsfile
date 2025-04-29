pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'    
        APP_NAME = 'online-shop'
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
                    sh "docker build -t ${IMAGE_NAME}."
                    withCredentials([usernamePassword(credentialsId: 'DockerHub-Creds', usernameVariable: 'DockerHubusername', passwordVariable: 'DockerHubpassword')]) {
                        sh """
                            echo ${DockerHubpassword} | docker login -u ${DockerHubusername} --password-stdin
                        """
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
    

