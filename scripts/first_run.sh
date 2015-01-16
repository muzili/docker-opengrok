pre_start_action() {
    mkdir $OPENGROK_INSTANCE_BASE
    mkdir $OPENGROK_INSTANCE_BASE/data
    mkdir $OPENGROK_INSTANCE_BASE/etc

    wget -O - https://java.net/projects/opengrok/downloads/download/opengrok-0.12.1.tar.gz | tar zxvf - -C /
    mv /opengrok-* opengrok
    cd /opengrok/bin
    ./OpenGrok deploy
}

post_start_action() {
    rm /first_run
}
