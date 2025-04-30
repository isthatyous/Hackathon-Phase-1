pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'    
        APP_NAME = 'online-shop'
        RELEASE = '1.0.0'
        DOCKER_USER = 'isthatyou'
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

        // stage('SonarQube analysis') {
        //     steps {
        //         withSonarQubeEnv('SonarQube-Server') {
        //             sh """$SCANNER_HOME/bin/sonar-scanner \
        //                   -Dsonar.projectName=online-shop \
        //                   -Dsonar.projectKey=online-shop \
        //             """
        //         }
        //     }
        // }

        stage('Build & Push') {
            steps {
                 script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    withCredentials([usernamePassword(credentialsId: 'DockerHub-Creds', usernameVariable: 'DockerHubusername', passwordVariable: 'DockerHubpassword')]) {
                        sh """
                            echo ${DockerHubpassword} | docker login -u ${DockerHubusername} --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub-Creds', usernameVariable: 'DockerHubusername', passwordVariable: 'DockerHubpassword')]) {
                    sh "trivy image ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

         stage('Trigger CD Job') {
            steps {
                echo "Updating the manifest file"
                 withCredentials([usernamePassword(credentialsId: 'Github', usernameVariable: 'gitHubusername', passwordVariable: 'gitHubpassword')]) {
                    sh "git config user.email shivamsingh22188@gmail.com"
                    sh "git config user.name isthatyous"
                    // change branch
                    sh 'cat k8s/online-shop/values.yaml'
                    sh "sed -i 's|tag: \".*\"|tag: \"${IMAGE_TAG}\"|' k8s/online-shop/values.yaml"
                    sh 'cat k8s/online-shop/values.yaml'
                    sh 'cat k8s/online-shop/values.yaml'
                    echo "========================================================"

                     // Add, commit, and push changes
                    sh 'git add k8s/online-shop/values.yaml'
                    sh "git commit -m 'Update image tag to ${IMAGE_TAG}' || echo 'No changes to commit'"
                    sh 'git remote set-url origin https://${gitHubusername}:${gitHubpassword}@github.com/isthatyou/your-repo-name.git'
                    sh 'git push origin feature/feature-branch-1'
                    

                }
                
            
                
            }
        }

      
            }
        }
    

