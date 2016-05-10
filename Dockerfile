# -----------------------------------------------------------------------------
# docker-mumble
#
# Tox mumble server
#
# Authors: Isaac Bythewood, Azim Sonawalla, Maxim Biro
# -----------------------------------------------------------------------------

FROM debian:jessie

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
VOLUME /data /cert

ENTRYPOINT /start
