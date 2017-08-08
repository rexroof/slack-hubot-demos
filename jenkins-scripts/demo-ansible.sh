#!/bin/bash

cd $WORKSPACE
git clean -f

PLAYBOOK=${PLAYBOOK-simple.yml}
PLAYBOOK=$(basename $PLAYBOOK)

if [ -n "${PLUGIN}" ] ; then
  mkdir -p ansible-playbooks/callback_plugins
  cp ansible-plugins/$PLUGIN ansible-playbooks/callback_plugins/
fi
 
cd $WORKSPACE/ansible-playbooks
ansible-playbook -vv ${PLAYBOOK}
