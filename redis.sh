#!/bin/bash
#REDIS Database Installation

ID=$(id -u)
TIMESTAMP=$(date +%F:::%X)
LOG="/tmp/$0===$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2....... $G Success $N"
    else
        echo -e "$2....... $R Failed $N"
        exit 1
    fi # END Condition
}

if [ $ID -eq 0 ]
then
    echo -e "$G You are the root access $N"
else
    echo -e "$R ERROR ..... You don't have access $N"
    exit 1
fi # END Condition

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
VALIDATE $? "Installing Redis on the server"

dnf module enable redis:remi-6.2 -y &>>$LOG
VALIDATE $? "Redis Module Enabled"

dnf install redis -y &>>$LOG
VALIDATE $? "Installing Redis"

sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "Allowing Remote Connections"

systemctl enable redis &>>$LOG
VALIDATE $? "Enable Redis Service"

systemctl start redis &>>$LOG
VALIDATE $? "Redis Service Started"