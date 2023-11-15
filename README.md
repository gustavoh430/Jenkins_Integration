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

Obs. The image already contain all plugins we need.

Then, we run the image just created to deploy our container.

```code
docker run -it -p 8080:8080 -d -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home custom-jenkins-docker
```
