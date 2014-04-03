FROM stackbrew/ubuntu:12.04
MAINTAINER Gordon Chiam <gordon.chiam@gmail.com>

# Common
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# install python-software-properties to get add-apt-repository
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y --force-yes python-software-properties

# install mariadb
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://download.nus.edu.sg/mirror/mariadb/repo/5.5/ubuntu precise main'
RUN apt-get update -qq
RUN apt-get install -y --force-yes mariadb-server

ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 664 /etc/mysql/conf.d/my.cnf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

# Disable binlog
RUN sed -i -e 's/^log_bin/#log_bin/' /etc/mysql/my.cnf
RUN sed -i -e 's/^log_bin_index/#log_bin_index/' /etc/mysql/my.cnf
RUN sed -i -e 's/^expire_logs_days/#expire_logs_days/' /etc/mysql/my.cnf
RUN sed -i -e 's/^max_binlog_size/#max_binlog_size/' /etc/mysql/my.cnf

VOLUME ["/var/lib/mysql"]
EXPOSE 3306
CMD ["/usr/local/bin/run"]
