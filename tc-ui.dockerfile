FROM node:latest
LABEL key="fnoliveira"
ENV NODE_ENV=development
COPY deploy/prod/ui/. /var/tc/docker/www
WORKDIR /var/tc/docker/www
RUN npm install 
ENTRYPOINT ["npm", "start"]
EXPOSE 3000