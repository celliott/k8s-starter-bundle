FROM node:8-alpine
MAINTAINER ctelliott@gmail.com

RUN apk add --update \
    vim \
  && rm -rf /var/cache/apk/*

WORKDIR /opt/app

ADD src/package.json .
RUN npm install -g

ADD src .
RUN chmod +x *.js

ENTRYPOINT ["./server.js"]
