#!/bin/bash
echo CruiseControl 系统安装

echo 安装 JAVA
# 注：只能装 Jdk 6. Jdk 7 有兼容性问题，会报错
# com.thoughtworks.xstream.converters.ConversionException: Cannot
# construct net.sourceforge.cruisecontrol.BuildLoopInformation as it
# does not have a no-args constructor
./jdk-6u37-linux-x64-rpm.bin # download from java.sun.com

echo 安装 CruiseControl
unzip cruisecontrol-bin-2.4.1.zip -d /opt
ln -s /opt/cruisecontrol-bin-2.4.1 /opt/cruisecontrol
 
echo 安装依赖包
yum install graphviz php-pecl-xdebug php-pecl-runkit
echo runkit.internal_override=1 >> /etc/php.d/runkit.ini

echo 安装 PHP-UnderControl
pear channel-discover components.ez.no
pear channel-discover pear.phpundercontrol.org
pear install --alldeps phpuc/phpUnderControl-beta

echo 安装 PHPUnit
pear channel-discover pear.phpunit.de
pear channel-discover components.ez.no
pear channel-discover pear.symfony-project.com
pear install --alldeps --force phpunit/PHPUnit

echo 安装 PHP-DOC
pear channel-discover pear.phpdoc.org
pear install phpdoc/phpDocumentor-alpha

echo 安装 PHPMD
pear channel-discover pear.phpmd.org
pear channel-discover pear.pdepend.org
pear install --alldeps phpmd/PHP_PMD

echo 安装 PHP-CPD
pear channel-discover components.ez.no
pear install -a ezc/eZComponents
pear config-set auto_discover 1
pear install pear.phpunit.de/phpcpd

echo 安装 PHP-Depend
pear channel-discover pear.pdepend.org
pear install pdepend/PHP_Depend-beta

echo export JAVA_HOME=/usr/java/latest/ >> /etc/profile
source /etc/profile

phpuc install /opt/cruisecontrol
phpuc setup-cc /opt/cruisecontrol /etc/init.d/

/opt/cruisecontrol/cruisecontrol.sh
echo Web 管理地址：http://127.0.0.1:8080/dashboard/tab/dashboard
echo               http://127.0.0.1:8080/cruisecontrol/
