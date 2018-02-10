FROM nginx:latest
LABEL key="fnoliveira" 
COPY deploy/prod/ui/src/assets /var/www/src/assets
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN chmod 755 -R /var/www/src/assets
EXPOSE 80 443
ENTRYPOINT ["nginx"]
# Parametros extras para o entrypoint
CMD ["-g", "daemon off;"]
