![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/f8a18cd2-3cf3-4dda-b0eb-545e942f368c)

# Jenkins pipeline

This project aims to create a CI/CD integration pipeline which will use the following application as example: https://github.com/gustavoh430/loginproject.

The final pipeline will looks like the image below:

![image](https://github.com/gustavoh430/Jenkins_Integration/assets/41215245/00d7c356-343f-4fda-9387-ab2085fe42e1)

The project uses GitHub plugin to clone our application, maven to build our java app, JUnit 5 to test, Docker to build an Image, Grype to check our image, Sonar to analyze our code and, finally, Docker again to run our application.

# Jenkins set up

First of all, it is necessary to create an image out of the code I shared (the Dockerfile archive). In order to do that, download it, place it on a desired folder and, then, run the following command to build the image:

```code
docker build -t jenkins-docker . 
```

Then, we run the image just created to deploy our container.

```code
 docker run --name jenkins  -p 8081:8080 -d  -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home jenkins-docker
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
 docker run -d --name sonarqube -p 9000:9000 sonarqube
```

Access it from http://localhost:9000 and login with the following credentials:

User: admin
Password: admin


