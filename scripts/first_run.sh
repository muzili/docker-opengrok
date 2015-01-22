pre_start_action() {
    LOG_DIR=/var/log
    mkdir $OPENGROK_INSTANCE_BASE
    mkdir $OPENGROK_INSTANCE_BASE/data
    mkdir $OPENGROK_INSTANCE_BASE/etc

    mkdir -p $LOG_DIR/supervisor
    mkdir -p /etc/supervisor/conf.d
    cat > /etc/supervisord.conf <<-EOF
[unix_http_server]
file=/run/supervisor.sock   ; (the path to the socket file)

[supervisord]
logfile=$LOG_DIR/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB       ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10          ; (num of main logfile rotation backups;default 10)
loglevel=info               ; (log level;default info; others: debug,warn,trace)
pidfile=/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=true               ; (start in foreground if true;default false)
minfds=1024                 ; (min. avail startup file descriptors;default 1024)
minprocs=200                ; (min. avail process descriptors;default 200)

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///run/supervisor.sock ; use a unix:// URL  for a unix socket

[include]
files = /etc/supervisor/conf.d/*.conf
EOF
    cat > /etc/supervisor/conf.d/grok.conf <<-EOF
[supervisord]
nodaemon=true

[program:opengrok]
command=$CATALINA_HOME/bin/catalina.sh run

[program:nginx]
command=/usr/sbin/nginx

[program:cron]
command=crond -n

EOF

    cat > /etc/nginx/sites-enabled/opengrok.conf <<EOF
upstream opengrok {
    server localhost:8080;
}
## This is a normal HTTP host which redirects all traffic to the HTTPS host.
server {
    listen 80;
    server_name $VIRTUAL_HOST;
    charset utf-8;

    location / {
        proxy_pass http://opengrok/;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$host;
    }
}
server {
  listen 443 ssl;
  server_name  $VIRTUAL_HOST;

  location / {
      proxy_pass http://opengrok/;
      proxy_set_header X-Forwarded-For \$remote_addr;
      proxy_set_header Host \$host;
  }

  ## SSL Security
  ## https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
  ssl on;
  ssl_certificate /etc/nginx/ssl/opengrok.crt;
  ssl_certificate_key /etc/nginx/ssl/opengrok.key;

  ssl_ciphers 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4';

  ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
  ssl_session_cache  builtin:1000  shared:SSL:10m;

  ssl_prefer_server_ciphers   on;

  add_header Strict-Transport-Security max-age=63072000;
  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;

  # logging
  error_log $LOG_DIR/nginx/error.log;
  access_log $LOG_DIR/nginx/access.log;
}
EOF
    mkdir -p $LOG_DIR/nginx
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -subj "/C=CN/ST=SH/L=SHANGHAI/O=MoreTV/OU=Helios/CN=muzili@gmail.com"  -keyout /etc/nginx/ssl/opengrok.key -out /etc/nginx/ssl/opengrok.crt

    cd /opengrok/bin
    ./OpenGrok deploy

    # Redirect the tomcat root to opengrok app
    cat > $CATALINA_HOME/webapps/ROOT/index.jsp <<EOF
<html>

<head>
<meta http-equiv="refresh" content="0;URL=http://$VIRTUAL_HOST/source/">
</head>

<body>
</body>

</html>
EOF
}

post_start_action() {
    rm /first_run
}
