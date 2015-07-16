# -*- coding: utf-8 -*-
'''
Salt module to manipulate disk images
'''
from __future__ import absolute_import

# Import python libs
import os
import re
import logging

# Import salt libs
import salt.utils
from salt.ext.six import string_types
from salt.utils import which as _which
from salt.exceptions import CommandNotFoundError, CommandExecutionError

# Set up logger
log = logging.getLogger(__name__)

# Define the module's virtual name
__virtualname__ = 'hdiutil'


def __virtual__():
    '''
    Only load on Mac OS
    '''
    if salt.utils.which('hdiutil') and __grains__['os'] == 'MacOS':
        return __virtualname__
    return False


def mount(name, user=None):
    '''
    Mount a disk image

    CLI Example:

    .. code-block:: bash

        salt '*' hdiutil.mount /path/to/dmg/file
    '''

    cmd = 'hdiutil mount {0}'.format(name)
    out = __salt__['cmd.run_all'](cmd, runas=user)
    if out['retcode']:
        return out['stderr']
    return True


def umount(name, user=None):
    '''
    Attempt to unmount a mounted volume

    CLI Example:

    .. code-block:: bash

        salt '*' hdiutil.umount /mnt/foo
    '''
    cmd = 'hdiutil unmount {0}'.format(name)
    out = __salt__['cmd.run_all'](cmd, runas=user)
    if out['retcode']:
        return out['stderr']
    return True
