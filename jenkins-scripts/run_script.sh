#!/bin/bash
set -x

# this is the core of our jenkins job
# - determine script name from environment and run it.

# exit if we aren't running in jenkins
if [ -z "$JENKINS_HOME" ] ; then
  echo JENKINS_HOME not set, cannot continue
  exit 1
fi

# figure out where this script is living
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# source common library functions
source "$SCRIPTDIR/library.sh"

# pseudo security precaution.
TARGET_SCRIPT=$(basename $JENK_SCRIPT)

if [ -f "$SCRIPTDIR/$TARGET_SCRIPT" ] ; then
  source $SCRIPTDIR/$TARGET_SCRIPT
  RETURN_CODE=$?
else
  echo "cannot find $TARGET_SCRIPT"
  exit 1
fi

if [ $RETURN_CODE -eq 0 ]
then
  echo "$TARGET_SCRIPT Success"
else
  slack "$TARGET_SCRIPT had exit code $RETURN_CODE"
fi
