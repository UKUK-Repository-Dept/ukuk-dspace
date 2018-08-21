from git import Repo
import subprocess

branch = 'develop'

build = """mvn clean
mvn package -Dmirage2.on=true
cp dspace.cfg dspace/target/dspace-installer/config/
cd dspace/target/dspace-installer
ant fresh_install
sudo systemctl restart tomcat"""

repo = Repo(".")
assert not repo.bare

if repo.head.ref != repo.heads[branch]:
    for command in build.split("\n"):
        print(command)
        print(subprocess.check_output(
            command,
            stderr=subprocess.STDOUT, 
            #shell=True #better output, security risk
            ))
