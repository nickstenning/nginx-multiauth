FROM phusion/baseimage:0.9.12

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

ENV SRC /opt/headers

RUN apt-get -q -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install python-minimal python-virtualenv nginx-light

RUN virtualenv $SRC
RUN $SRC/bin/pip install flask
ADD serve.py $SRC/serve.py

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./htpasswd /etc/nginx/htpasswd

ADD ./svc /etc/service
CMD ["/sbin/my_init"]

EXPOSE 80
