#!/bin/bash

CFGHUB=$HOME/.cfghub
mkdir -p $CFGHUB/.defaults/`dirname $1`

cp $1 $CFGHUB/.defaults/$1
cp $1 $CFGHUB/.defaults/$1-`date +%Y%m%d%H%M`.backup

echo "===>"
ls $1 -alh

echo
diff $1 $CFGHUB/`basename $1`
echo

sudo rm $1
sudo ln -s $CFGHUB/`basename $1` `dirname $1`

echo "<==="
ls $1 -alh
