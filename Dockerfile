FROM jenkins/jenkins:lts
MAINTAINER Brian Scheck <schecbr@gmail.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Used to set the docker group ID
# Set to 497 by default, which is the group ID used by AWS Linux ECS Instance
ARG DOCKER_GID=497

# Create Docker Group with GID
# Set default value of 497 if DOCKER_GID set to blank string by Docker Compose
RUN groupadd -g ${DOCKER_GID:-497} docker

# Used to control Docker and Docker Compose versions installed
# NOTE: As of February 2016, AWS Linux ECS only supports Docker 1.9.1
ARG DOCKER_ENGINE=1.10.2
ARG DOCKER_COMPOSE=1.6.2

# Install base packages
RUN apt-get update -y && \
    apt-get install apt-transport-https curl python-dev python-setuptools gcc make libssl-dev \
    ca-certificates software-properties-common -y && \
    easy_install pip 


RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install docker-ce -y && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
#RUN pip install docker-compose==${DOCKER_COMPOSE:-1.6.2} && \
#    pip install ansible boto boto3

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
#COPY plugins.txt /usr/share/jenkins/plugins.txt
#RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
