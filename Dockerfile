FROM jenkins/jenkins
USER root
RUN apt-get update && apt-get install docker-ce
RUN apt-get update && apt-get install lsb-release
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN /usr/local/bin/install-plugins.sh \
blueocean \
build-environment \
cloudbees-folder \
config-file-provider \
credentials-binding \
credentials \
docker-plugin \
docker-slaves \
git \
pipeline-utility-steps \
grypescanner \
sonar 
USER root
