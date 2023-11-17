![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/f8a18cd2-3cf3-4dda-b0eb-545e942f368c)

# Jenkins pipeline

This project aims to create a CI/CD integration pipeline which will use the following application as example: https://github.com/gustavoh430/loginproject.

The final pipeline will looks like the image below:

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/8375fd91-23d2-448f-a1ca-c135dbd3ec87)


The project uses GitHub plugin to clone our application, maven to build our java app, JUnit 5 to test, Docker to build an Image, Grype to check our image, Sonar to analyze our code and, finally, Docker again to run our application.

# Jenkins set up

First of all, it is necessary to create an image out of the code I shared (the Dockerfile archive). In order to do that, download it, place it on a desired folder and, then, run the following command to build the image:

```code
docker build -t jenkins-docker . 
```

Before running, let's create a network in docker. This will be usefull to make our jenkins and sonar communicate with each other.

```code
 docker network create jenkins_net
```

Then, we run the image just created to deploy our container.

```code
 docker run --name jenkins  -p 8082:8082 -d --network jenkins_net -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home jenkins-docker
```



"**-v /var/run/docker.sock:/var/run/docker.sock**": This flag mounts the Docker socket on the host machine to the Docker socket inside the container. This allows the Jenkins instance to communicate with the Docker daemon.

"**-v jenkins_home:/var/jenkins_home**": This flag mounts a directory on the host machine to the /var/jenkins_home directory inside the container. This is where Jenkins stores its configuration and data.


After that, we must configure our Jenkins. The following image will pop up and we must insert a code to unlock jenkins:

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/237a0aab-c440-4a85-a53c-9d672c72fa30)


In order to achieve that, we type the code below to get the passwort to install jenkins:

```code
 docker logs jenkins
```

This code will get the container logs as showed below. 

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/bf4b5165-9f40-4da8-9c90-0d2f4b0b1f47)

Finally, we copy the code from the log and paste it on jenkins. Then, choose to install the standard packages and sign up.


## Configuring Maven

We already downloaded it during the image creation. With that in mind, we just need to download the Maven plugin and inform jenkins where our package lies on (feel free to upgrade jenkins).

Go to "Manage Jenkins -> Plugins -> Available Plugins" and look for "Maven". Choose "Maven Integration" like the image below.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/730f1abb-20c8-475b-a2eb-084fd03df85a)


After installing the plugin, we go to "Manage Jenkins -> Tools -> look for "Jenkins Installations" and click on "Add Maven". With that, we fill the fields out like the image below. ]
Apply and save it.


![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/faac3e42-60fe-4fc5-a074-c3b9d9b0a386)


We can already get the other plugins which will be necessary:

Blue Ocean

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/a00e608a-cf3c-40b2-8cb8-1f527d50d0bc)


SonarQube Scanner

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/fdb831c5-3aca-4b59-8f56-6bf650865ecf)


GrypeScanner

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/fa23fc5f-20c4-4e08-9495-9a1707a5fe72)


Docker Pipeline

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/360c7e22-018e-4690-8b4e-c87e8076a489)


## Configuring SonarQube

Pull the Sonar image from Docker Hub, using:

```code
 docker pull sonarqube
```

Then, run this image to create a container em port 9000.

```code
 docker run -d --name sonarqube --network jenkins_net -p 9000:9000 sonarqube
```

Access it from http://localhost:9000 and login with the following credentials:

User: admin
Password: admin


Going ahead, it is necessary to install a package inside our jenkins path to make our just created caontainer communicate with jenkins. To do that, firstly, create a sonar-scanner directory under /var/jenkins_home and, then, download SonarQube Scanner (wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip)

```code
 docker exec -it jenkins bash
```

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/0f1202e9-8bb3-489b-b8cb-e2646dcfb9b8)

In case which you do not have "wget" installed, use:

```code
 apt-get install wget
```

Download SonarQube package:

```code
 wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
```

Then, unzip it:

```code
 unzip sonar-scanner-cli-5.0.1.3006-linux.zip
```

After that, go to Manage Jenkins -> Tools and click on "Add SonarQube Installation" and configure like the image below:

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/cff9c7a1-69c0-416b-a473-6114ace50b18)

Click on "Apply" and "Save".

Once we already set up the SonarQube Installations it's time to configure SonarQube Server. Considering we are running Jenkins as well as Sonar on a Docker container, sharing the same network, they are accessible from each other. With that in mind, let's check the containers ip.

```code
docker network inspect jenkins_net
```

```json
[
    {
        "Name": "jenkins_net",
        "Id": "cb10e08de51b27b3921f1569ed8b4ab93ced15f52ecc009dd3c8071332c32c6d",
        "Created": "2023-11-16T09:17:26.43303887Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "97ed98aff41f8699ff00d00b69298caf8a59a28f007759251e57791a6cd48dc0": {
                "Name": "jenkins",
                "EndpointID": "222262c9dbc7b238ed61d716a6fde6a9846e29109a58114b4aab6b4c71e32f9e",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "c05554afc4add98afdc79cd677a217b48b558792cbb0bd2c5a4630fc7e688c08": {
                "Name": "sonarqube",
                "EndpointID": "c42a4e260cb730e350775fe33b0c0028f3ace79f0fdce6590431306a0c3c8e0b",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

As seen, the sonarqube ip is: "172.18.0.3". Thus, this will be the address which we are going to use during SonarQube Server configuring.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/96b6f140-4ac2-4f08-9f68-eb8949c45653)


Then, in order to prepare SonarQube, we go to our SonarQube from http://localhost:9000, click on "Create a Local Project"

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/0723e73c-1fa4-4eaf-ac06-63e52aac429f)

Give a name to your Sonar repository and click "Next". 

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/175e2489-dcca-48dc-8c1c-4ecbe63d18e3)

Then, flag "Use the Global Setting" and click on "Create Project"
As soon as we follow these steps, we are ready to click on "Locally" to generate a access token which will be used to connect from Jenkins.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/2f332a51-ff3a-40ca-9ee2-2041cbe81d72)

Copy the code and click on "Continue"

code generated: sqp_1c85b1f08775b76009d1be84e9a1699d8af9894e

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/e2ae8f18-5e6f-4dc4-b1eb-98c2ff32d815)


After that, we go back to Jenkins. There, we go to "Manage Jenkins" -> "Credentials" -> "System" -> "Global credentials (unrestricted)"

Firstly, we define a name to this server (I choose "Sonar").
After these steps, we click on "Advanced" -> "+ Add" -> "Jenkins". When a new window pops up, we choose "Secret Text" in "Kind", paste our Sonar key there and give an "id" to this key (I named it as "Sonar_Secret"

Finally, just pick the token secret just create from the list in "Server Authentication token" and click on "Create Credential". There, we choose "Secret Text" as "Kind". We also provide our SonarQube token in "Secret" and we must also choose an ID to our Secret.


![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/a162fe08-0e1a-4a37-905f-6acb4c0e9669)

With all these steps followed, we have just configured our SonarQube Scanner.

## Creating Docker Credentials

Go to credentials (follows the steps mentioned above) and create a credentials with "Kind" equals to "Username with Password". Here we use our Docker Hub Credentials as username and password.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/bcb46103-c76d-40af-b8cc-9234d9d1586e)

Remember to create a repository on DockerHub ("https://github.com/gustavoh430/Docker-EKS")

## Setting up Grype

We must follow the Grype Documtation to install it properly (https://github.com/anchore/grype/blob/main/README.md).

Basically, we only need to install a package on a certain folder and install grype plugin (already done).

Grype package

```code
docker exec -it jenkins bash
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
```


# Creating Jenkins Pipeline

In Jenkins home, go to "+ New Item", give a name to it and select "Pipeline".

Finally, paste the following code on "Script":

It is important to pay attention to "environment" section, because we are defining our Environment Variables. It contains our repository on DockerHub (gustavoh430/loginappjenkins) as well as the GitHub repostiory (https://github.com/gustavoh430/loginproject.git).

**Edit these environment variables to suit your case.**

Then, save it.

```jenkins
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
  
```

Once you have followed all these steps, we are ready to start the pipeline.


# Starting Pipeline with Blue Ocean

Inside our pipeline, click on "Open Blue Ocean"

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/c3a7834e-4c5e-4ccf-b550-492c0b91d229)


Click on Run (This image only pops up if we are running it for the first time).

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/72f89217-da88-4282-9b6d-0b1d9bb906a0)


Click on the line that has just appeared. After this, the running pipeline status will be visible to us.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/b2b174d8-626d-4c9b-88f7-d2a8252ca612)


We should run the pipe successfully like the image below

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/8375fd91-23d2-448f-a1ca-c135dbd3ec87)


# Checking the application report from SonarQube

Access the project we have created befone on SonarQube, through "http://localhost:9000". Here, we can see that our application passed the verification without any blocks (we did not configured). Furthermore, we also see that there are some Bugs, vulnerabilities and Code smells.

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/0bd12f4c-907a-472e-85e8-0ee3831b91a5)


# Checking the image report generated from Grype

Still in Blue Ocean, click on "Check Image Security: Grype" step and, then, on "Vulnerability scan with grype".

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/0139179e-c3b7-4983-8e0f-e00cf92bb185)

Here, we have a summary of grype scanning. However, if we want to see a more detailed information, click on "Artifacts" on the top of the page and download the archive "myScanResult.txt"

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/1aead342-9fe8-49b7-91d9-b6c129dd97ef)


# Ckecking test results

On Blue Ocean Page, click on "Tests". This will return the following information (saying how many tests have passed).

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/c7d18b02-d146-4268-abac-1ecf0cb1d91e)

