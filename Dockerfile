#
# Docker container for custom ESN used in OGP
#

FROM node:6.5.0-slim
MAINTAINER Linagora Folks

RUN sed -i 's/httpredir.debian.org/deb.debian.org/g' /etc/apt/sources.list
RUN apt-get update --fix-missing
RUN apt-get install -y git \
            libjpeg-dev \
            graphicsmagick \
		    graphicsmagick-imagemagick-compat \
		    libpango1.0-dev \
		    libcairo2-dev

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/openpaas
RUN git clone --depth=1 https://github.com/linagora/openpaas-esn.git .
RUN git clone --depth=1 https://github.com/vishnubob/wait-for-it.git wait-for-it
RUN cp /opt/openpaas/wait-for-it/wait-for-it.sh /usr/bin/wait-for-it.sh

RUN npm install --production
RUN npm install -g bower && bower install --allow-root

RUN cp docker/config/docker-db.json config/db.json
RUN cp docker/scripts/start.sh start.sh
RUN cp docker/scripts/provision.sh provision.sh

EXPOSE 8080

CMD ["sh", "start.sh"]
