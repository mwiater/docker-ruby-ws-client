FROM ruby:alpine

RUN apk update && \
  apk upgrade && \
  apk add --no-cache \
  build-base bash nano

RUN echo "docker ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers && \
  addgroup -S docker && \
  adduser -S -g docker -s /bin/bash docker && \
  echo "docker:docker" | chpasswd

RUN mkdir /home/docker/wsClient

COPY containerFiles /home/docker/wsClient

RUN cd /home/docker/wsClient && \
  chmod 777 -R ../wsClient && \
  chown docker:docker -R ../wsClient && \
  gem install bundler && \
  bundle install

WORKDIR /home/docker/wsClient

USER docker

CMD ["ruby","client.rb"]