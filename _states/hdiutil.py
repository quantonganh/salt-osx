# -*- coding: utf-8 -*-
'''
Mounting a disk image
=====================

.. code-block:: yaml

    adium:
      hdiutil:
        - mounted
        - name: /path/to/dmg/file
'''
from __future__ import absolute_import

# Import python libs
import os.path
import re

# Import salt libs
from salt.ext.six import string_types

import logging
import salt.ext.six as six
log = logging.getLogger(__name__)
from salt._compat import string_types


def mounted(name,
            user=None):
    '''
    Verify that a disk image is mounted

    name
        The path of the dmg file
    user
        Which use to run this command with
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    out = __salt__['hdiutil.mount'](name, user=user)
    if isinstance(out, string_types):
        # Failed to (re)mount, the state has failed!
        ret['comment'] = out
        ret['result'] = False
        return ret
    else:
        # (Re)mount worked!
        ret['comment'] = 'Target was successfully mounted'
        ret['changes']['mount'] = True

    return ret


def unmounted(name,
              user=None):
    '''
    Verify that a disk image is not mounted

    name
        The path to the location where the disk image is to be unmounted from

    user
        Which user to run which command with
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    out = __salt__['mount.umount'](name, user=user)
    if isinstance(out, string_types):
        # Failed to umount, the state has failed!
        ret['comment'] = out
        ret['result'] = False
    elif out is True:
        # umount worked!
        ret['comment'] = 'Target was successfully unmounted'
        ret['changes']['umount'] = True
    else:
        ret['comment'] = 'Execute set to False, Target was not unmounted'
        ret['result'] = True

    return ret
