def ls():
    '''List all services available in /etc/init.d
    
    CLI Example::
      salt '*' sysvinit.ls
    '''
    return __salt__['cmd.run']('ls /etc/init.d')
