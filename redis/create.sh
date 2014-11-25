#!/bin/sh
docker create --name redis -p 6379:6379 -t hnakamur/redis
