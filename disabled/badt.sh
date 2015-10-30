#!/bin/bash
find /home/lot/workspace/ | sed '/.svn/d;/phpexcel\/Documentation/d;/_tmp/d;/.sass-cache/d;/.git/d;/.pyc/d;' | cpio -o > dttools.all.cpio
# find /home/lot/workspace/ -mtime -3 ! -type d | sed '/.svn/d;/phpexcel\/Documentation/d;/_tmp/d;/.sass-cache/d;/.git/d;/.pyc/d;' | cpio -o > dttools.all.0.cpio
