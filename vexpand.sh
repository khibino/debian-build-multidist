#! /bin/sh

PATH="/usr/bin:/bin"

if [ -r debian/changelog ]; then
	chf=debian/changelog
else
	chf=orig-debian/changelog
fi

if [ ! -r $chf ]; then
	exit 1
fi

version=$(dpkg-parsechangelog -l$chf | grep '^Version: ' | sed 's@^Version: @@')
sed -e "s/@version@/$version/g"
