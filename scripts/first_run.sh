pre_start_action() {
    mkdir $OPENGROK_INSTANCE_BASE
    mkdir $OPENGROK_INSTANCE_BASE/data
    mkdir $OPENGROK_INSTANCE_BASE/etc

    mkdir -p /etc/supervisor/conf.d
    cat > /etc/supervisor/conf.d/supervisord.conf <<-EOF
[supervisord]
nodaemon=true

[program:opengrok]
command=$CATALINA_HOME/bin/catalina.sh run

EOF

    cd /opengrok/bin
    ./OpenGrok deploy
}

post_start_action() {
    rm /first_run
}
