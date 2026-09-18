FROM ubuntu:noble
LABEL maintainer="NPPM Team <nppm-team@ub.uni-tuebingen.de>"

# Set non-interactive mode for UBUNTU to avoid interruptions
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependencies
RUN apt-get --yes update
RUN apt-get --yes install mysql-server openjdk-21-jre tomcat10

# MySQL configuration
RUN echo "collation-server = utf8_unicode_ci" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "character-set-server = utf8" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "group_concat_max_len = 100000000" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "log_bin_trust_function_creators = 1" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# MySQL DB + user
COPY resources/schema.sql /schema.sql
RUN mysqld --daemonize && echo "CREATE DATABASE nppm;" | mysql
RUN mysqld --daemonize && cat /schema.sql | mysql nppm
RUN mysqld --daemonize && echo "CREATE USER 'nppm'@'localhost' IDENTIFIED BY 'nppm';" | mysql
RUN mysqld --daemonize && echo "GRANT ALL PRIVILEGES ON nppm.* TO 'nppm'@'localhost';" | mysql
RUN mysqld --daemonize && echo "FLUSH PRIVILEGES;" | mysql

# tomcat configuration & app
ENV CATALINA_HOME=/usr/share/tomcat10
ENV CATALINA_BASE=/var/lib/tomcat10
ENV CATALINA_TMPDIR=/tmp
RUN sed -i 's/<servlet-class>org.apache.jasper.servlet.JspServlet<\/servlet-class>/<servlet-class>org.apache.jasper.servlet.JspServlet<\/servlet-class><init-param><param-name>strictQuoteEscaping<\/param-name><param-value>false<\/param-value><\/init-param>/g' /etc/tomcat10/web.xml
COPY resources/nppm.xml /etc/tomcat10/Catalina/localhost/nppm.xml
COPY resources/nppm.war /var/lib/tomcat10/webapps/nppm.war
EXPOSE 8080

# start services when container is run
COPY resources/startup.sh /startup.sh
CMD [ "/startup.sh" ]
