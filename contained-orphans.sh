#!/bin/dash

exec /usr/bin/unshare -Upfm --mount-proc dash ./orphans.sh
