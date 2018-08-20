#!/bin/bash
cd /opt/dspace.build/

if [ ! -f /var/lib/dspace/build -o -f /var/lib/dspace/buildlock ]; then
   echo 'No event. Not updated.'
   exit 0
fi

rm -f /var/lib/dspace/build
touch /var/lib/dspace/buildlock

#first parameter is branch name
BRANCH=$1 

#Check if there are changes
if git checkout $BRANCH &&
    git fetch origin $BRANCH &&
    [ `git rev-list HEAD...origin/$BRANCH --count` != 0 ] &&
    git merge origin/$BRANCH
then
    #Changes found -> Rebuild dspace
    mvn clean
    mvn package -Dmirage2.on=true
    cp dspace.cfg dspace/target/dspace-installer/config/
    cd dspace/target/dspace-installer
    ant fresh_install
    sudo systemctl restart tomcat
else
    #No changes
    echo 'No git change. Not updated.'
fi

rm -f /var/lib/dspace/buildlock

