#!/usr/bin/env bash

bundle exec rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  bundle exec rake db:create && \
  bundle exec rake db:migrate
fi
rm -rf tmp/pids/server.pid
rm -rf crt/.gitkeep
bundle exec rake db:seed

foreman start $CONFIG_START_UP
