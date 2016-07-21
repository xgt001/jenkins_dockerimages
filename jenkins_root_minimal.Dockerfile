FROM jenkins:latest
USER root
RUN apt-get update && apt-get install sudo 
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

