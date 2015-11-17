#!/bin/dash

exec /usr/bin/unshare -pfm --mount-proc dash ./orphans.sh
