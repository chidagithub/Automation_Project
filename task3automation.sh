#!/bin/bash
myname="chidananada"
s3_bucket="upgrad-chidananda"
timestamp=$(date '+%d%m%Y-%H%M%S')
touch /var/www/html/inventory.html
cat > /var/www/html/inventory.html << EOF

<!DOCTYPE html>
<html>
<body>
    <b>Log-Type &ensp; Date created &ensp; Size &ensp; Type</b>
</body>
</html>

EOF

sudo tar cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2 *.log
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
s3filename=$(aws s3 ls ${s3_bucket} --recursive | sort | tail -n 1 | awk '{print $5}')
s3filetype=${s3filename##*.}
s3logstype="httpd-logs"
logdate=$(aws s3 ls ${s3_bucket} --recursive | sort | tail -n 1 | awk '{print $1" "$2}')
filesize=$(aws s3 ls ${s3_bucket} --recursive --human-readable | sort | tail -n 1 | awk '{print $3 $4}')
appendline=$(<p>$s3logstype &ensp; $logdate &ensp; $filesize &ensp; $s3filetype </p>)
head -n 5 var/www/html/inventory.html; echo $appendline; tail -n +3 var/www/html/inventory.html;
