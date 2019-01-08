#!/bin/bash
#FAQ not working -> check buildlock
cd /opt/dspace.build/

if [ ! -f /var/lib/dspace/build -o -f /var/lib/dspace/buildlock ]; then
   exit 0
fi

git pull
./build.sh
rm -f /var/lib/dspace/build

