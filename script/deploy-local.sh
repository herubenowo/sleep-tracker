#!/usr/bin/env bash
rm -rf tmp/pids/server.pid
rm -rf crt/.gitkeep
bundle exec rails s -b 0.0.0.0
