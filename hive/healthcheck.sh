#!/bin/bash
netstat -an | grep 9083 > /dev/null; if [ 0 != $? ]; then exit 1; fi;