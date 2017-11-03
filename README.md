# Build
docker build -t mattwiater/ruby-ws-client .

# Development
docker build -t mattwiater/ruby-ws-client . && \
  docker run -it --rm --env NODE_ID="0059f712-c795-4b97-9179-5e2096fed14a" --name ruby-ws-client mattwiater/ruby-ws-client

# Run: Interactive
docker build -t mattwiater/ruby-ws-client . && \
  docker run -it --rm --env NODE_ID="0059f712-c795-4b97-9179-5e2096fed14a" --name ruby-ws-client mattwiater/ruby-ws-client /bin/ash

$ Run: Detached
docker run -d --rm -p 80:9292 --env NODE_ID="0059f712-c795-4b97-9179-5e2096fed14a" --name ruby-ws-client mattwiater/ruby-ws-client

# Multi
docker build -t mattwiater/ruby-ws-client . && \
  docker run -it --rm --env NODE_ID="0059f712-c795-4b97-9179-5e2096fed14a" --name ruby-ws-client-01 mattwiater/ruby-ws-client

docker build -t mattwiater/ruby-ws-client . && \
  docker run -it --rm --env NODE_ID="bc32d677-8997-4ed8-9bde-30cc88bd4286" --name ruby-ws-client-02 mattwiater/ruby-ws-client