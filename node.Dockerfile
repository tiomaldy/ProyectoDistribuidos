# use this empty Dockerfile to build your assignment

# This dir contains a Node.js app, you need to get it running in a container
# No modifications to the app should be necessary, only edit this Dockerfile

# Overview of this assignment
# use the instructions from developer below to create a working Dockerfile
# feel free to add command inline below or use a new file, up to you (but must be named Dockerfile)
# once Dockerfile builds correctly, start container locally to make sure it works on http://localhost
# then ensure image is named properly for your Docker Hub account with a new repo name
# push to Docker Hub, then go to https://hub.docker.com and verify
# then remove local image from cache
# then start a new container from your Hub image, and watch how it auto downloads and runs
# test again that it works at http://localhost


# Instructions from the app developer
# - you should use the 'node' official image, with the alpine 6.x branch
FROM centos:centos7
RUN echo "ACTUALIZANDO CENTOS"
RUN yum update -y

RUN echo "INSTALANDO NODEJS 12"
RUN yum install -y gcc-c++ make
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install nodejs -y


RUN echo "INSTALANDO PROYECTO TIA ACTIVATION SERVER"
EXPOSE 3004
RUN mkdir -p /usr/src/app
WORKDIR /user/src/app
COPY package.json package.json
RUN npm install
COPY . .

#RUN echo "export TIA_WEBSERVICE_jwtPrivateKey=MALABO2020" >> ~/.bash_profile
#RUN source ~/.bash_profile

RUN yum localinstall -y oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
RUN yum localinstall -y oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm

RUN export ORACLE_HOME=/usr/lib/oracle/12.1/client64
RUN export TNS_ADMIN=$ORACLE_HOME/network/admin
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
RUN export PATH=$PATH:$ORACLE_HOME/bin

RUN mkdir -p /usr/lib/oracle/12.1/client64/network/admin
RUN cp tnsnames.ora /usr/lib/oracle/12.1/client64/network/admin
RUN ln -s /usr/include/oracle/12.1/client64 $ORACLE_HOME/include
RUN touch /etc/ld.so.conf.d/oracle.conf
RUN echo "/usr/lib/oracle/12.1/client64/lib" >> /etc/ld.so.conf.d/oracle.conf
RUN ldconfig

RUN echo "ELIMINANDO ARCHIVOS DE INSALACION"
RUN rm -f oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
RUN rm -f oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
RUN rm -f tnsnames.ora


RUN echo "INSTALACION FINALIZADA"
CMD ["node", "index.js"]
RUN echo "SERVIDOR LEVANTADO"
# - this app listens on port 3000, but the container should launch on port 80
  #  so it will respond to http://localhost:80 on your computer
#EXPOSE 3003
# - then it should use alpine package manager to install tini: 'apk add --update tini'
# - then it should create directory /usr/src/app for app files with 'mkdir -p /usr/src/app'
#RUN mkdir -p /usr/src/app
# - Node uses a "package manager", so it needs to copy in package.json file
#WORKDIR /user/src/app
#COPY package.json package.json
# - then it needs to run 'npm install' to install dependencies from that file
#RUN npm install
# - to keep it clean and small, run 'npm cache clean --force' after above
# - then it needs to copy in all files from current directory
#COPY . .
#RUN export TIA_WEBSERVICE_jwtPrivateKey=MALABO2020
# - then it needs to start container with command '/sbin/tini -- node ./bin/www'
#CMD ["node", "index.js"]
# - in the end you should be using FROM, RUN, WORKDIR, COPY, EXPOSE, and CMD commands

# Bonus Extra Credit
# this will not have you setting up a complete image useful for local development, test, and prod
# it's just meant to get you started with basic Dockerfile concepts and not focus too much on
# proper Node.js use in a container. **If you happen to be a Node.js Developer**, then 
# after you get through more of this course, you should come back and use my 
# Node Docker Good Defaults sample project on GitHub to change this Dockerfile for 
# better local development with more advanced topics
# https://github.com/BretFisher/node-docker-good-defaults
