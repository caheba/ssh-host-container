FROM debian:latest

MAINTAINER Carsten Bachert "<caba@bachert.info>"

RUN apt-get update && apt-get -y install sudo git openssh-server

RUN sed -i 's/PermitRootLogin\ without-password/PermitRootLogin\ no/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port\ 2222/' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd

RUN useradd -m -d /opt/ruth ruth
RUN cd /opt/ruth && mkdir .ssh && chmod 700 .ssh && chown -R ruth:ruth .ssh
RUN sudo adduser ruth sudo
RUN echo "ruth ALL=NOPASSWD: ALL">>/etc/sudoers
RUN echo "PasswordAuthentication no">> /etc/ssh/sshd_config

COPY ./run.sh /scripts/run.sh
RUN chmod 777 /scripts/run.sh

EXPOSE 2222

ENTRYPOINT [ "/scripts/run.sh" ]

