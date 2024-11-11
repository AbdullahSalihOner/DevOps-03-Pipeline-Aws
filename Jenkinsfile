pipeline {
    // agent {label 'My-Jenkins-Agent'}
    agent any
    tools {
        jdk 'JDK21'
        maven 'Maven3'
    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from SCM') {
            steps {
                //   checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AbdullahSalihOner/DevOps-03-Pipeline-Aws']])
                git branch: 'master', credentialsId: 'github', url: 'https://github.com/AbdullahSalihOner/DevOps-03-Pipeline-Aws'
            }
        }
        stage('Build Maven') {
            steps {
                //  sh 'mvn clean install'
                //  bat 'mvn clean install'
                sh 'mvn clean package'
                //  bat 'mvn clean package'
            }
        }
        stage('Test Application') {
            steps {
                sh 'mvn test'
                //  bat 'mvn test'
            }
        }


       stage("SonarQube Analysis"){
           steps {
	           script {
		           withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                      sh "mvn sonar:sonar"
		           }
	           }
           }
       }



        /*
        stage('Docker Image') {
           steps {
               //  sh 'docker build  -t asoner01/my-application:latest  .'
                  bat 'docker build  -t asoner01/my-application:latest  .'
           }
        }


        stage('Docker Image to DockerHub') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {

                        //  sh 'echo docker login -u asoner01 -p DOCKERHUB_TOKEN'
                        // bat 'echo docker login -u asoner01 -p DOCKERHUB_TOKEN'

                        // sh 'echo docker login -u asoner01 -p ${dockerhub}'
                          bat 'echo docker login -u asoner01 -p ${dockerhub}'

                        // sh 'docker image push  asoner01/my-application:latest'
                           bat 'docker image push  asoner01/my-application:latest'
                    }
                }
            }
        }


        stage('Deploy to Kubernetes'){
            steps{
                kubernetesDeploy (configs: 'deployment-service.yml', kubeconfigId: 'kubernetes')
            }
        }


       stage('Docker Image to Clean') {
           steps {
               //   sh 'docker rmi asoner01/my-application:latest'
               //  bat 'docker rmi asoner01/my-application:latest'

               // sh 'docker image prune -f'
                bat 'docker image prune -f'
           }
       }
*/
    }
}