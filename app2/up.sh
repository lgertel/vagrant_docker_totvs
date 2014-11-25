#!/bin/sh
CURRENT_DIR=/data/app2
RAILS_ENV=development
export RAILS_ENV

PATH=/usr/local/bin:/bin:/sbin
export PATH

cd $CURRENT_DIR
bundle install --jobs 4 --path vendor/bundle --binstubs vendor/bin
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec unicorn -c $CURRENT_DIR/config/unicorn/local.rb -E development -D
