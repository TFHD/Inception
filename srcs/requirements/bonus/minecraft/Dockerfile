FROM debian:bullseye

RUN apt-get update && apt-get -y upgrade
RUN apt install -y vim iputils-ping wget curl tar
RUN apt install -y openjdk-11-jdk openjdk-11-jre 

WORKDIR /server

RUN wget https://piston-data.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar
COPY eula.txt .
ENTRYPOINT ["java", "-Xms1024m", "-Xmx2560m","-jar","server.jar","nogui;"]
