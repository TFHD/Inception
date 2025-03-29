FROM debian:bullseye
RUN apt update -y && apt upgrade -y && apt install -y vsftpd openssl openssh-server

COPY ./tools/script.sh /

RUN chmod +x ./script.sh

CMD ["./script.sh"]
