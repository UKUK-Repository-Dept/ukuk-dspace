#!/usr/bin/python3

import subprocess
import os
import logging
import logging.handlers
import time
import argparse

BUILD_COMMANDS = [
  ["git", "pull"],
  ["mvn", "clean"],
  ["mvn", "package", "-Dmirage2.on=true"],
  ["cp", "dspace.cfg dspace/target/dspace-installer/config/"],
  ["cd", "dspace/target/dspace-installer"],
  ["ant", "fresh_install"],
  ["sudo", "systemctl", "restart", "tomcat"],
]

# ARGUMENTS
parser = argparse.ArgumentParser()
parser.add_argument("--branch", help="choose develop or master", choices=["develop", "master"], default="develop")
parser.add_argument("--logfile", help="path+name of logfile", default="dspace-build.log")
parser.add_argument("--loop",action="store_true", help="run in infinit loop")
parser.add_argument("--lock", help="path+name of lockfile", default="/var/lib/dspace/build")
args = parser.parse_args()

# LOGGING
logging.basicConfig(level=logging.DEBUG,filename=args.logfile)
log = logging.getLogger("dspace")
log.setLevel(logging.DEBUG)
# create file handler 
handler = logging.handlers.RotatingFileHandler(
              args.logfile, maxBytes=1000000, backupCount=3)
# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
# add the handlers to the logger
log.addHandler(handler)

log.info("Starting script.")

def run_shell_command(command_line):
    log.info('Subprocess "%s" starts.', " ".join(command_line))
    try:
        command_line_process = subprocess.Popen(
            command_line,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        output, error =  command_line_process.communicate()
        log.info("output: %s",output)
        if error:
            log.error("error: %s",error)
    except (OSError) as exception:
        log.error('Exception occured: ' + str(exception))
        log.error('Subprocess "%s" failed.', " ".join(command_line))
        return False
    else:
        log.info('Subprocess "%s" finished.'," ".join(command_line))
    return True


def rebuild():
    for command in BUILD_COMMANDS:
        run_shell_command(command)
        #TODO posilat mail když spadne

if args.loop:
    while True:
        if os.path.isfile(args.lock):
            log.info('Building')
            rebuild()
            os.remove(args.lock)
        time.sleep(1)
else:
   rebuild()
