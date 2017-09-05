# -*- coding: utf-8 -*-
# Copyright 2012 Dag Wieers <dag@wieers.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os
import json
import urllib, urllib2
import pprint

from ansible.module_utils.six import string_types
from ansible.module_utils._text import to_bytes
from ansible.plugins.callback import CallbackBase

class CallbackModule(CallbackBase):
    """
    This Ansible callback plugin posts errors to hubot endpoint.
    """
    CALLBACK_VERSION = 2.0
    CALLBACK_NAME = 'slack_snippet'

    def slack_snippet(self, result):
        hubot_url = 'http://localhost'
        if os.environ.get('HUBOT_URL') is not None:
                hubot_url = os.environ.get('HUBOT_URL')

        slack_room='button'
        if os.environ.get('SK_CHANNEL') is not None:
                slack_room = os.environ.get('SK_CHANNEL')

        hubot_url='{}/snippet/{}'.format(hubot_url,slack_room)

        delegated_vars = result._result.get(
                            '_ansible_delegated_vars', 
                            None)
        if delegated_vars:
            target_host = delegated_vars['ansible_host']
        else:
            target_host = result._host.get_name()

        # using BUILD_TAG environment variable to see if we're in jenkins.
        # if so, then post this to slack
        if os.environ.get('BUILD_TAG') is not None:
            pp = pprint.PrettyPrinter(indent=2)
            snippet_filename = os.environ.get('BUILD_TAG')
            results_output = pp.pformat(result._result)

            snippet_contents = "{}\n[{}]\n{}".format(
               self.task, 
               target_host, 
               results_output )
            headers = { 'Content-type': 'application/json' }
            data = { 
              'filename' : snippet_filename, 
              'content'  : snippet_contents 
            }
            data = json.dumps(data)
            req = urllib2.Request(hubot_url, data, headers) 
            response = urllib2.urlopen(req)
            print( "hubot returned http status {}".format( 
                response.getcode() ) 
            )

    def v2_runner_on_failed(self, result, ignore_errors=False):
        if not ignore_errors:
            self.slack_snippet(result)

    def v2_runner_on_unreachable(self, result):
        self.slack_snippet(result)

    def v2_runner_on_async_failed(self, result):
        self.slack_snippet(result)

    def v2_playbook_on_play_start(self, play):
         self.play = play

    def v2_playbook_on_task_start(self, task, is_conditional):
        self.task = task
