FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV TZ Asia/Shanghai
ENV PROJECT_NAME FutuOpenD
COPY ./FutuOpenD_7.1.3308_NN_Ubuntu16.04 /${PROJECT_NAME}/
RUN apt-get update && apt-get install -y telnet
WORKDIR ${PROJECT_NAME}