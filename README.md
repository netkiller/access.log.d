access.log
==========

Example
-------
    cat /var/log/nginx/access.log | libexec/log --format=nginx --db=mongo --table=bbs
    cat /var/log/nginx/access.log | libexec/log -f nginx -d mongo -t bbs
