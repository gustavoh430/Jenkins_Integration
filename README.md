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




