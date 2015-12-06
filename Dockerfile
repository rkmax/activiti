#
# Ubuntu 14.04 with activiti and node
#
# Pull base image.
FROM dockerfile/java:oracle-java8
MAINTAINER Julian Reyes Escrigas "jreyes@bix.com.uy"

# Install the base dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y supervisor git redis-server nodejs npm postgresl
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

RUN npm install -g nodemon

ENV TOMCAT_VERSION 8.0.14
ENV ACTIVITI_VERSION 5.17.0
ENV POSTGRES_CONNECTOR_JAVA_VERSION 9.4-1201.jdbc41
ENV MONARCH_BACKEND_BRANCH dev

RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz
RUN wget https://github.com/Activiti/Activiti/releases/download/activiti-${ACTIVITI_VERSION}/activiti-${ACTIVITI_VERSION}.zip -O /tmp/activiti.zip
RUN wget https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_JAVA_VERSION}.jar -O /tmp/postgresql-${POSTGRES_CONNECTOR_JAVA_VERSION}.jar

# Unpack
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

RUN unzip /tmp/activiti.zip -d /opt/activiti

# Remove unneeded apps
RUN rm -rf /opt/tomcat/webapps/examples
RUN rm -rf /opt/tomcat/webapps/docs

# To install jar files first we need to deploy war files manually
RUN unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-explorer.war -d /opt/tomcat/webapps/activiti-explorer
RUN unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-rest.war -d /opt/tomcat/webapps/activiti-rest

# Add postgres connector to application
RUN cp /tmp/postgresql-${POSTGRES_CONNECTOR_JAVA_VERSION}.jar /opt/tomcat/webapps/activiti-rest/WEB-INF/lib/
RUN cp /tmp/postgresql-${POSTGRES_CONNECTOR_JAVA_VERSION}.jar /opt/tomcat/webapps/activiti-explorer/WEB-INF/lib/

# Add roles
ADD assets /assets
RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

EXPOSE 8080
EXPOSE 3000
EXPOSE 5432

CMD ["/assets/init"]

