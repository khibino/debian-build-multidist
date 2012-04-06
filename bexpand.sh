#! /bin/sh

PATH="/usr/bin:/bin"

builder="$1"
if [ x"$builder" = x ]; then
	echo "$0: argument required!!"
	exit 1
fi

builder_lc=$(echo $builder | tr a-z A-Z)

sed \
	-e "s/@builder@/${builder}/g" \
	-e "s/@BUILDER@/${builder_lc}/g"
