
FROM centos:centos7
RUN echo "ACTUALIZANDO CENTOS"
RUN yum update -y

RUN echo "INSTALANDO NODEJS 12"
RUN yum install -y gcc-c++ make
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install nodejs -y


RUN echo "INSTALANDO PROYECTO TIA ACTIVATION SERVER"
RUN mkdir -p /usr/src/app
WORKDIR /user/src/app
COPY package.json package.json
RUN npm install
COPY . .


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

