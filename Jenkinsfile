pipeline {
    agent none
    stages {
        stage("Test Django app"){
            agent {
                docker {
                    image 'python:3'
                    args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'master',url:'https://github.com/afermor8/django_tutorial2.git'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test')
                {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }
            }
        }
        stage("Build and Push Docker Image"){
            environment {
                IMAGE_NAME = "afermor8/django_tutorial2"
                DOCKERHUB_CREDENTIALS = 'USER_DOCKERHUB'
            }
            agent any
            stages {
                stage('Clone') {
                    steps {
                        git branch:'master',url:'https://github.com/afermor8/django_tutorial2.git'
                    }
                }
                stage('Build'){
                    steps{
                        script {
                            newApp = docker.build("$IMAGE_NAME:$BUILD_NUMBER")
                        }
                    }
                }
                stage('Push') {
                    steps {
                        script {
                            docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Clean Up') {
                    steps {
                        sh 'docker rmi $IMAGE_NAME:$BUILD_NUMBER'
                    }
                }
                stage('Deploy') {
                    steps {
                        script {
                            sshagent(credentials: ['ssh_jenkins']) {
                                sh "ssh -o StrictHostKeyChecking=no arantxa@walle.afm-tars.es 'cd /home/arantxa/git/django_tutorial ; sudo docker-compose down'"
                                sh "ssh -o StrictHostKeyChecking=no arantxa@walle.afm-tars.es sudo docker pull $IMAGE_NAME:$BUILD_NUMBER"
                                sh "ssh -o StrictHostKeyChecking=no arantxa@walle.afm-tars.es sudo wget https://raw.githubusercontent.com/afermor8/django_tutorial2/master/docker-compose.yml -O docker-compose.yml"
                                sh "ssh -o StrictHostKeyChecking=no arantxa@walle.afm-tars.es sudo VERSION=$BUILD_NUMBER docker-compose up -d --force-recreate"
                            }
                        }
                    }
             
                }
            }
            post {
                always {
                    mail to: 'ara.fer.mor@gmail.com',
                    subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
                    body: "${env.BUILD_URL} has result ${currentBuild.result}"
                }
            }
            
        }

    }
}
