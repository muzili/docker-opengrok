pre_start_action() {
    mkdir $OPENGROK_INSTANCE_BASE
    mkdir $OPENGROK_INSTANCE_BASE/data
    mkdir $OPENGROK_INSTANCE_BASE/etc

    mkdir /opengrok
    tar --strip-components=1 -zxvf /tmp/opengrok.tgz -C /opengrok/
    cd /opengrok/bin
    ./OpenGrok deploy
}

post_start_action() {
    rm /first_run
}
