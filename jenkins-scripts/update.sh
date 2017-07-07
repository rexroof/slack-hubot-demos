#!/bin/bash
# this updates our scripts directory on to the jenkins server for use by other jobs

# exit if we aren't running in jenkins
if [ -z "$JENKINS_HOME" ] ; then
  echo JENKINS_HOME not set, cannot continue
  exit 1
fi

if [ -d "$WORKSPACE/scripts" ] ; then
  rsync -av --delete \
    $WORKSPACE/scripts/ \
    ${JENKINS_HOME}/scripts/
else
  echo $WORKSPACE/scripts not found, cannot continue
  exit 1
fi
