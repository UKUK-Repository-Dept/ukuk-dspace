#!/usr/bin/python3

import git
import subprocess
import os
import logging
import logging.handlers
import time

LOG_FILENAME = 'dspace-build.log'

BUILD_COMMANDS = [
  "mvn clean",
  "mvn package -Dmirage2.on=true",
  "cp dspace.cfg dspace/target/dspace-installer/config/",
  "cd dspace/target/dspace-installer",
  "ant fresh_install", "ls", "sudo systemctl restart tomcat",
]

# LOGGING
logging.basicConfig(level=logging.INFO)
log = logging.getLogger("dspace")
# create file handler 
handler = logging.handlers.RotatingFileHandler(
              LOG_FILENAME, maxBytes=200000, backupCount=3)
# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
# add the handlers to the logger
log.addHandler(handler)

log.info("Preparing.")
try:
    branch = os.environ['BRANCH']
    assert branch in ["develop","master"]
    log.info("Branch set: %s",branch)
except (KeyError, AssertionError):
    print("Set enviroment variable $BRANCH to 'develop' or 'master'.")
    exit()

def run_shell_command(command_line):
    log.info('Subprocess: "' + command_line + '"')
    try:
        command_line_process = subprocess.Popen(
            command_line,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )

        output, error =  command_line_process.communicate()

        # process_output is now a string, not a file,
        # you may want to do:
        # process_output = StringIO(process_output)
        log.info("output: %s",output)
        if error:
            log.error("error: %s",error)
    except (OSError) as exception:
        log.error('Exception occured: ' + str(exception))
        log.error('Subprocess "%s" failed',command_line)
        return False
    else:
        # no exception was raised
        log.info('Subprocess finished')
    return True


def pull(repo): 
    #fetch
    repo.remotes["origin"].fetch()
    commits_ahead = repo.iter_commits("origin/"+branch+".."+branch)
    print("commits",len(list(commits_ahead)))
    if False:
        log.info("No changes in branch %s.", branch)
        return False
    else:
        repo.remotes["origin"].pull()
        log.info("Pull %s.", branch)
        return True

def rebuild():
    for command in BUILD_COMMANDS:
        run_shell_command(command)
        #TODO posilat mail když spadne

repo = git.Repo(".")
assert not repo.bare
#assert not repo.is_dirty()

while True:
    if pull(repo):
        rebuild()
    time.sleep(60)
