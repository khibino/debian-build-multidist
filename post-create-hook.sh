#! /bin/sh

echo 'I: calling apt-get '"$@" >&2
/usr/bin/apt-get "$@"
