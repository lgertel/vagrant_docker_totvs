#!/bin/sh
bundle install --jobs 4 --path vendor/bundle --binstubs vendor/bin
bundle exec rake db:create
bundle exec rake db:migrate
