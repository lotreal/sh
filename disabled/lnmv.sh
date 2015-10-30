#!/bin/bash
SP="${0%/*}"
mv $1 $2
ln -s $2/`basename $1` `dirname $1`