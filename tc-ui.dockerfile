FROM node:latest
LABEL key="fnoliveira"
ENV NODE_ENV=development
COPY /var/tc/deploy/prod/ui/. /var/www
WORKDIR /var/www
RUN npm install 
ENTRYPOINT ["npm", "start"]
EXPOSE 3000