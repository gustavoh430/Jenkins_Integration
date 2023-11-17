pipeline {
    agent any

    environment {
        // Define environment variables
        MAVEN_HOME = tool 'Maven'
        repository = "gustavoh430/loginappjenkins"
        dockerImage = ''
        gitImage= "https://github.com/gustavoh430/loginproject.git"
        dockerCredentials= 'dockerCred_id'
    }
    
    stages {
        
        stage('Cloning our Git') {
            steps {
                git branch:'loginproject_h2', url: gitImage
            }
        }
        
        stage('Build') {
            steps {
                script {
                    def mvnHome = tool 'Maven'
                    sh "${mvnHome}/bin/mvn clean install -DskipTests=true"
                }
            }
        }
        stage('Test') {
            steps {
              sh "chmod +x -R ${env.WORKSPACE}"
              sh(script: './mvnw --batch-mode -Dmaven.test.failure.ignore=true test')
            }
            post {
                always {
                     junit(testResults: 'target/surefire-reports/*.xml', allowEmptyResults : true)
                        }
                }

        }
        
         stage('Creating Docker Image') {
                steps{
                    script {
                        dockerImage = docker.build repository
                            }
                    }
                }
                
        stage('Update Docker Hub Image') {
                steps{
                    script {
                    docker.withRegistry( '', dockerCredentials ) {
                    dockerImage.push("$BUILD_NUMBER")
                    dockerImage.push('latest')
                        }
                    }
                }
        }
        
        stage("SonarQube Analysis") {
            
                steps {
                        script{
                        
                        withSonarQubeEnv('SonarServer') {
                        sh "mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=loginproject \
                        -Dsonar.projectName='loginproject'"
                            }
                        }
                }
                
                
            }
            
            
        
        
        stage('Check Image Security: Grype') {
                steps{
                    script {
                    sh 'grype $repository --scope AllLayers'
                    grypeScan scanDest: 'dir:/var/jenkins_home', repName: 'myScanResult.txt', autoInstall:true
                    }
                }
        }
        
        stage ("Shutting Down Running Containers") {
	            steps {
		                script {
		                    sh 'docker ps -f name=loginproject -q | xargs --no-run-if-empty docker container stop'
                            sh 'docker container ls -a -fname=loginproject -q | xargs -r docker container rm'
		                }
	        }
        }
        
        stage('Deploy: Docker Container') {
                steps{
                    script {
                    docker.image("$repository:$BUILD_NUMBER").run ("-p 8080:8080 -d --name loginproject")
                    }
                }
        }
        


    }
}
  