#!/bin/dash

exec watch -n 0.3 'pstree -Up | grep dash'
