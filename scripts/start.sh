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

# link mounted source directory to opengrok
rm -rf $OPENGROK_INSTANCE_BASE/src
ln -fs /source $OPENGROK_INSTANCE_BASE/src

exec supervisord
