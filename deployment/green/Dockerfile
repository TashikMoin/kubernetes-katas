FROM nginx:alpine 
COPY default.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/green/
CMD ["nginx", "-g", "daemon off;"]
