FROM openjdk:16-slim

ARG webgoat_version=8.2.1-SNAPSHOT
ARG webgoat_FILE=target/webgoat-server-${webgoat_version}.jar
ARG webwolf_FILE=target/webwolf-server-${webgoat_version}.jar

ENV webgoat_version_env=${webgoat_version}

RUN apt-get update
RUN useradd -ms /bin/bash webgoat
RUN apt-get -y install apt-utils nginx

USER webgoat

COPY --chown=webgoat docker/nginx.conf /etc/nginx/nginx.conf
COPY --chown=webgoat docker/index.html /usr/share/nginx/html/
COPY --chown=webgoat docker/target/webgoat-server-${webgoat_version}.jar /home/webgoat/webgoat.jar
COPY --chown=webgoat ${webwolf_version}.jar /home/webgoat/webwolf.jar
COPY --chown=webgoat docker/start.sh /home/webgoat

EXPOSE 8080
EXPOSE 9090

WORKDIR /home/webgoat
ENTRYPOINT /bin/bash /home/webgoat/start.sh $webgoat_version_env
