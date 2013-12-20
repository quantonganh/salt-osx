Diamond
=======

Install diamond, a daemon and toolset for gather system statistics
and publishing them to graphite.

Mostly operating system related such as CPU, memory.

but it's often plug with third party daemon such as PostgreSQL to gather
those stats as well.
Each of those other daemons state come with their own configuration file
that are put in /etc/diamond/collectors, directory check at startup for
additional configurations.
