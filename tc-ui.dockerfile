FROM node:9.5-alpine as node-angular-cli
LABEL key="fnoliveira"
ENV NODE_ENV=development
RUN mkdir -p /var/www

COPY deploy/prod/ui/. /var/www
WORKDIR /var/www
RUN apk update \
  && apk add --update alpine-sdk \
  && apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache verify \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd

#Angular CLI
RUN npm install -g @angular/cli@latest

RUN npm install
ENTRYPOINT ["npm", "start"]
EXPOSE 4200