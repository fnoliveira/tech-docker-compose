FROM node:9.5-alpine as node-angular-cli
LABEL key="fnoliveira"
RUN mkdir -p /var/www

COPY deploy/prod/ui/. /var/www
WORKDIR /var/www

RUN npm i -g @angular/cli@latest
RUN npm cache clear --force 
RUN npm cache verify
RUN npm install
ENTRYPOINT ["npm", "build"]
EXPOSE 4200