############################################################
# Dockerfile that creates a container for running Gate One.
# Inside the container Gate One will run as the 'gateone'
# user and will listen on port 8000.  docker run example:
#
#   docker run -t --name=gateone -p 443:8000 gateone
#
# That would run Gate One; accessible via port 443 from
# outside the container.  It will also run in the foreground
# with pretty-printed log output (so you can see what's
# going on).  To run Gate One in the background:
#
#   docker run -d --name=gateone -p 443:8000 gateone
#
# You could then stop or start the container like so:
#
#   docker stop gateone
#   docker start gateone
#
# The script that starts Gate One inside of the container
# performs a 'git pull' and will automatically install the
# latest code whenever it runs.  To disable this feature
# simply pass --noupdate when running the container:
#
#   docker run -d --name=gateone -p 443:8000 gateone --noupdate
#
# Note that merely stopping & starting the container doesn't
# pull in updates.  That will only happen if you 'docker rm'
# the container and start it back up again.
#
############################################################

FROM index.boxlinker.com/library/ubuntu:14.04
MAINTAINER liuzhangpei <liuzhangpei@126.com>


# Ensure everything is up-to-date
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get -y upgrade

# Install dependencies; 分开安装,为了防止网络问题导致中断
RUN apt-get -y install python-pip
RUN apt-get -y install python-imaging
RUN apt-get -y install python-setuptools
RUN apt-get -y install python-mutagen
RUN apt-get -y install python-pam
RUN apt-get -y install python-dev
RUN apt-get -y install git
RUN apt-get -y install telnet
RUN apt-get -y install telnet
RUN apt-get -y install openssh-client
RUN apt-get -y clean
RUN apt-get -q -y autoremove


RUN pip install --upgrade futures tornado cssmin slimit psutil


# Create the necessary directories, clone the repo, and install everything
RUN mkdir -p /gateone/logs && \
    mkdir -p /gateone/users && \
    mkdir -p /etc/gateone/conf.d && \
    mkdir -p /etc/gateone/ssl && \
    mkdir -p /gateone/GateOne


ADD . /gateone/GateOne


RUN cd /

RUN cd /gateone/GateOne && \
    python setup.py install && \
    cp update_and_run_gateone.py /usr/local/bin/update_and_run_gateone && \
    cp 60docker.conf /etc/gateone/conf.d/60docker.conf

EXPOSE 8000

# This ensures our configuration files/dirs are created:
RUN /usr/local/bin/gateone

## Remove the auto-generated ey/certificate so that a new one gets created the
## first time the container is started:
#RUN rm -f /etc/gateone/ssl/key.pem && \
#    rm -f /etc/gateone/ssl/certificate.pem
## (We don't want everyone using the same SSL key/certificate)
#
#
#
#
##CMD ["/usr/local/bin/update_and_run_gateone", "--log_file_prefix=/gateone/logs/gateone.log"]
#CMD ["/usr/local/bin/update_and_run_gateone"]

# docker build -t index.boxlinker.com/liuzhangpei/gateone .
# docker run -d --name=gateone -p 4433:8000 index.boxlinker.com/liuzhangpei/gateone
# docker run -it index.boxlinker.com/liuzhangpei/gateone bash