#FROM ubuntu:14.04
FROM circleci/buildpack-deps:trusty

ENV DIST ubuntu14.04
ENV DEBIAN_FRONTEND noninteractive

RUN sudo dpkg-reconfigure --frontend noninteractive tzdata
RUN sudo apt-get update
RUN sudo apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential git curl lsb-release unzip 
RUN sudo apt-get clean

RUN sudo gem install --no-rdoc --no-ri json_pure --version 1.7.7
RUN sudo gem install --no-rdoc --no-ri fpm-cookery
