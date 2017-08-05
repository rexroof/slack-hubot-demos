#!/bin/bash

# triggered via hubot/jenkins
# run ansible with optional plugin copied into callback_plugins

cd $WORKSPACE/ansible-playbooks
rm -rf callback_plugins && mkdir callback_plugins
cp $WORKSPACE/ansible-plugins/slack_snippet.py callback_plugins/

ansible-playbook -vv snippet.yml
