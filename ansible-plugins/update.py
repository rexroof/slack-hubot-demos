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
import time
import urllib, urllib2

from ansible.module_utils.six import string_types
from ansible.module_utils._text import to_bytes
from ansible.plugins.callback import CallbackBase

class CallbackModule(CallbackBase):
    """
    This Ansible callback plugin posts errors to hubot endpoint.
    """
    CALLBACK_VERSION = 2.0
    CALLBACK_NAME = 'slack_update'

    def slack_update(self):
        hubot_url = 'http://localhost'
        if os.environ.get('HUBOT_URL') is not None:
                hubot_url = os.environ.get('HUBOT_URL')

        slack_room='button'
        if os.environ.get('SK_CHANNEL') is not None:
                slack_room = os.environ.get('SK_CHANNEL')
        
        build_tag=hex(int(time.time()))
        if os.environ.get('BUILD_TAG') is not None:
            build_tag = os.environ.get('BUILD_TAG')

        hubot_url='{}/status-post/{}'.format(hubot_url,build_tag)
        headers = { 'Content-type': 'application/json' }
        data = json.dumps({ 
          'channel' : channel, 
          'message' : "{}".format(self.task) 
        })
        req = urllib2.Request(hubot_url, data, headers) 
        response = urllib2.urlopen(req)
        print("hubot update status {}".format( 
            response.getcode() ) 
        )

    def v2_playbook_on_task_start(self, task, is_conditional):
        self.task = task
        self.slack_update()
