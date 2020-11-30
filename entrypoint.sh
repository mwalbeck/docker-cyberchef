#!/bin/sh
set -eu

rm -rf /var/www/cyberchef/*
cp -r /cyberchef/* /var/www/cyberchef

exec "$@"
