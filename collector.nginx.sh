#!/bin/bash
logfile=/var/tmp/collector-$(date -d today +%Y%m%d).log
logdir=/var/log/nginx
#prefix=access.log
#yesterday=$(date -d yesterday +%Y%m%d)
#zcat $logdir/$prefix-$(date -d yesterday +%Y%m%d).gz
storage="mongo 192.169.0.5/logging -uxxx -pxxx"
#storage="mysql -hlocalhost -ulog -p123456 logging"

for logfile in $(ls $logdir/*-$(date -d yesterday +%Y%m%d).gz)
do
	zcat ${logfile} | ${storage} >> ${logfile}
done 
