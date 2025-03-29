FROM debian:bullseye

RUN apt-get update && apt-get -y upgrade
RUN apt install -y vim iputils-ping wget curl tar
RUN apt install -y openjdk-11-jdk openjdk-11-jre 

WORKDIR /server

RUN wget https://piston-data.mojang.com/v1/objects/fe123682e9cb30031eae351764f653500b7396c9/server.jar
COPY eula.txt .
EXPOSE 25565
ENTRYPOINT ["java", "-Xms1024m", "-Xmx2560m","-jar","server.jar","nogui;"]
