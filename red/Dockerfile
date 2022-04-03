FROM nginx:alpine 
COPY default.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/red/
CMD ["nginx", "-g", "daemon off;"]
