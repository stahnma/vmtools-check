#!/bin/bash
#                                                                                                               
# vmtools-check    Ensures your VMwareTools package is ok.
#
# chkconfig: 345 19 80
#
# description: vmtools-check makes sure your VMwareTools package is updaed \ 
# and configured for the kernel you are running.  If you decide to move \ 
# versions of VMwareTools, simply place the new one in an available yum \ 
# yum repository. 
#
# This really isn't a daemon, it's just a verification/fix script\
# that is processed upon bootup normally. It's a hack, but a hack \ 
# that works. 

# Source function library.
. /etc/init.d/functions   

start() {
        [ ! -f /var/libexec/vmtools-check/vmtools-check.rb ] && \
           /var/libexec/vmtools-check/vmtools-check.rb 
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] 
        return $RETVAL
}

stop() {
        RETVAL=0
        echo
        [ $RETVAL -eq 0 ] 
        return $RETVAL
}

restart() {
     start
}

status() {
     stop
}

case "$1" in
    start|stop|restart|reload)
        $1
        ;;
    status)
        fdrstatus
        ;;
    force-reload|condrestart|try-restart|reload
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|reload|force-reload}"
        exit 3
esac
exit $?
