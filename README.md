# Automation_Project
This project is about writing a bash script for below requirements
Hosting Web Server: The first step is to set up a web server on the EC2 instance for hosting a website. It is also important to ensure that the apache2 server is running and it restarts automatically in case the EC2 instance reboots.

Execute below shell script to install, start and enable apache2 server to automatic restart. 
#!/bin/bash
sudo apt update
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2


Archiving Logs: Daily requests to web servers generate lots of access logs. These log files  serve as an  important tool for troubleshooting.  However, these logs can also result in the servers running out of disk space and can make them stop working. To avoid this, one of the best practices is to create a backup of these logs by compressing the logs directory and archiving it to the s3 bucket (Storage). 

Creating tmp directory to store apache2 web server access logs in compressed format.
mkdir tmp

All this becomes a weekly/daily activity. These tasks can take a long time if done manually again and again. 
Bash script named ‘automation. sh’ will help  to automate all these workflows.

#defining myname variable
myname="chidananada"  

#defining s3_bucket name
s3_bucket="upgrad-chidananda"

#defining timestamp to get the current timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

#creating compressed file ${myname}-httpd-logs-${timestamp}.tar which contains all .log files of apache2 web server 
sudo tar cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2 *.log

#copying compressed file generated to s3 bucket
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
