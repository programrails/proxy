Create a file:

touch /etc/nginx/sites-available/proxy

Edit it:

server {
listen 185.158.153.134:80;
access_log /var/log/nginx/proxy.log;

location / {
proxy_pass http://127.0.0.1;
}

# location ~ "/(\w*-){3,}." { # a simplier one
location ~ "/([\w.~:?#[\]@!$&'()+,;=%]*-){3,}." {
proxy_pass http://blog.mysite.com;
}
}

Do this:

# ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/proxy
# /etc/init.d/nginx restart