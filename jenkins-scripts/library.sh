#!/bin/bash
source /etc/profile

# common library.

# if we have an JSON_OPTIONS base64 blob, convert it to exported environment:
declare -x $(echo $JSON_OPTIONS | base64 --decode | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" )  # we want word splitting.

# some default values for often-used variables
export JENK_SCRIPT=${JENK_SCRIPT-update.sh}
export SK_CHANNEL=${SK_CHANNEL-jenkins}
export SK_REPLY=${SK_REPLY-nobody}
export HUBOT_URL=${HUBOT_HOSTNAME-http://localhost/}  # should be a global jenkins variable 

# function for posting to slack
function slack {
   JS=$(jq -n --arg m "$1" '{"message": $m}')
   curl -Ss -XPOST -H "Content-Type: application/json" \
      -d "$JS" \
      "${HUBOT_URL}/say/${SK_CHANNEL}"
}
export -f slack

# creates our own set -e function
function trap_error {
  scriptfile=${JENK_SCRIPT-$0}
  if [ "$scriptfile" == "update.sh" ]; then
    scriptfile=$0
  fi
  slack "@${SK_REPLY} ${scriptfile} _jenkins job failed on line $1_ ${BUILD_URL}console"
  exit 1
}
trap 'trap_error $LINENO' ERR

# this gives us a new empty activated virtualenv
function create_virtualenv {
   export VENV="$(mktemp -d ${JENKINS_HOME}/tmp/venv_${JOB_NAME}_XXXXX)"
   virtualenv "$VENV"
   source "$VENV/bin/activate"
   pip install --upgrade pip
}
export -f create_virtualenv

# this gives us a new activated virtualenv with ansible
function ansible_virtualenv {
   export VENV="$(mktemp -d ${JENKINS_HOME}/tmp/venv_${JOB_NAME}_XXXXX)"
   virtualenv "$VENV"
   source "$VENV/bin/activate"
   pip install --upgrade pip
   # not sure why we need pytz here
   pip install ansible boto requests pytz httplib2
}
export -f ansible_virtualenv

# find a repo and cd into it. simple but gives us room to abstract
function find_repo {
  REPO=${1}
  if [ -z "$REPO" ] ; then
     echo "please provide repo name"
     exit 1
  fi
  if [ -d "${JENKINS_HOME}/workspace/$REPO" ] ; then
    cd "${JENKINS_HOME}/workspace/$REPO"
  else
    echo "cannot find $REPO"
    exit 1
  fi
}
export -f find_repo

# delete our virtualenv
function venv_cleanup {
  for vdir in $VENV $VIRTUAL_ENV
  do
    if [ -n "$vdir" ] ; then
      if [ -d "$vdir" ] ; then
        rm -rf $vdir
      fi
    fi
  done
}
export -f venv_cleanup
