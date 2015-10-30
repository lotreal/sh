#!/bin/bash
_SCRIPT_PATH=$(dirname $(readlink -f $0))
_HOME=$(cd $_SCRIPT_PATH/../ && pwd)
cd $_HOME

_FTP_REV_RANGE=$1
if test -z "$_FTP_REV_RANGE"
then
    _LOCAL_VER=$(svn info |grep Revision: |awk   '{print $2}')
    _REMOTE_VER_FILE=$_HOME/server.rev
    if test -f $_REMOTE_VER_FILE ; then
        _REMOTE_VER=$(cat $_REMOTE_VER_FILE)
    else
        echo 'err'
        exit
    fi
    _FTP_REV_RANGE=$(($_LOCAL_VER-$_REMOTE_VER))
fi

# _FTP_DIR=ecshop\\/themes
_FTP_DIR=trunk

_TEMP_DIR=$(mktemp -d)
echo  $_TEMP_DIR
pwd
echo "准备修改过的文件..."
svn log -l $_FTP_REV_RANGE -q -v | sed 's/^ *//' | sed -n '/^[AMR] \//p' | sort | uniq | cut -d ' ' -f 2 | sed 's/^\///' | sed 's/qu\///' | sed /^$_FTP_DIR/p -n | xargs -t -i cp --parents {} $_TEMP_DIR -r

# 删除 .svn 文件夹
find $_TEMP_DIR -type d -iname .svn -exec rm -rf {} \; 2> /dev/null

echo "开始上传文件..."
ncftpput -R -m -f ~/etc/ftp-test.qu.cc / $_TEMP_DIR/$_FTP_DIR/*

echo 清空临时目录 $_TEMP_DIR ...

