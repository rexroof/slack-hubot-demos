#!/bin/bash

cd $WORKSPACE
git clean -d -x -f

PLAYBOOK=${PLAYBOOK-website.yml}
PLAYBOOK=$(basename $PLAYBOOK)

if [ -n "${PLUGIN}" ] ; then
  IFS=',' read -a plugin_array <<< "$PLUGIN"
  for plugfile in "${plugin_array[@]}"
  do
    mkdir -p ansible-playbooks/callback_plugins
    cp ansible-plugins/${plugfile} ansible-playbooks/callback_plugins/
  done
fi
 
cd $WORKSPACE/ansible-playbooks

if [ -f ${PLAYBOOK} ] ; then
  slack "starting \`ansible-playbook -vv ${PLAYBOOK}\`"
  ansible-playbook -vv ${PLAYBOOK}
  if [ $? -eq 0 ]
  then
    slack "demo.neomyte.net successfully finished"
  else
    slack "demo.neomyte.net error code $?"
  fi
else
  slack "cannot find ${PLAYBOOK}"
fi
