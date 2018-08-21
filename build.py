#!/usr/local/bin/python3

import git
import subprocess
import os

try:
    branch = os.environ['BRANCH']
    assert branch in ["develop","master"]
except KeyError and AssertionError:
    print("Set enviroment variable $BRANCH to 'develop' or 'master'.")

build = """mvn clean
mvn package -Dmirage2.on=true
cp dspace.cfg dspace/target/dspace-installer/config/
cd dspace/target/dspace-installer
ant fresh_install
sudo systemctl restart tomcat"""

repo = git.Repo(".")
assert not repo.bare

if repo.head.ref != repo.heads[branch]:
    for command in build.split("\n"):
        print(command)
        print(subprocess.check_output(
            command,
            stderr=subprocess.STDOUT, 
            #shell=True #better output, security risk
            ))
