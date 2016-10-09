FROM debian:jessie

# HTTP redirect often causes apt-get to fail as Docker would cache things from previous container run
RUN sed -i "s/httpredir.debian.org/ftp.us.debian.org/" /etc/apt/sources.list

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mumble-server supervisor pwgen && \
    apt-get autoremove && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists

ADD ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD ./scripts/start /start
RUN chmod +x /start

EXPOSE 64738
VOLUME /data

ENTRYPOINT /start
