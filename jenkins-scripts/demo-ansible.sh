#!/bin/bash

cd $WORKSPACE
git clean -f

PLAYBOOK=${PLAYBOOK-website.yml}
PLAYBOOK=$(basename $PLAYBOOK)

if [ -n "${PLUGIN}" ] ; then
  mkdir -p ansible-playbooks/callback_plugins
  cp ansible-plugins/$PLUGIN ansible-playbooks/callback_plugins/
fi
 
cd $WORKSPACE/ansible-playbooks

if [ -f ${PLAYBOOK} ] ; then
  slack "starting \`ansible-playbook -vv ${PLAYBOOK}\`"
  ansible-playbook -vv ${PLAYBOOK}
  slack "demo finished"
else
  slack "cannot find ${PLAYBOOK}"
fi
