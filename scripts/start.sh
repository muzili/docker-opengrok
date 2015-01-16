#!/bin/bash
# Starts up the Phabricator stack within the container.

# Stop on error
#set -e

if [[ -e /first_run ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

pre_start_action
post_start_action

service tomcat7 start

# link mounted source directory to opengrok
ln -fs /source $OPENGROK_INSTANCE_BASE/src

# first-time index
echo "** Running first-time indexing"
cd /opengrok/bin
./OpenGrok index

# ... and we keep running the indexer to keep the container on
echo "** Waiting for source updates..."
touch $OPENGROK_INSTANCE_BASE/reindex
inotifywait -mr -e CLOSE_WRITE $OPENGROK_INSTANCE_BASE/src | while read f; do
  printf "*** %s\n" "$f"
  echo "*** Updating index"
  ./OpenGrok index
done

