#!/bin/bash
#CART configuring on ROBOSHOP Project

ID=$(id -u)
TIMESTAMP=$(date +%F-%X)
LOG="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
P="\e[35m"
N="\e[0m"

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2....$G..... Success $N"
    else
        echo -e "$R.....$2..... Failure $N"
        exit 1
    fi #END Condition
}

if [ $ID -eq 0 ]
then
    echo -e "$Y You are root user : $N"
else
    echo -e "$R You are not root user : $N"
    exit 1
fi #END Condition

#Installing CART Role on a AWS VM

dnf module disable nodejs -y &>>$LOG
VALIDATE $? "NODEJS Module Disabled"

dnf module enable nodejs:18 -y &>>$LOG
VALIDATE $? "Enabled NodesJS"

dnf install nodejs -y &>>$LOG
VALIDATE $? "Installing NodeJS"

#User Add Creation

if [ $ID -eq 0 ]
then
    echo -e "$Y ::: Roboshop user already created :: $P Skipping $N"
else
    useradd roboshop
    VALIDATE $? "Roboshop User Created"
fi #END Condition

mkdir -p /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOG
VALIDATE $? "Downloading the CART"

cd /app 

unzip -o /tmp/cart.zip  &>> $LOG
VALIDATE $? "Extracting the cart"

npm install &>>$LOG
VALIDATE $? "Dependencies Installing"

cp /home/centos/Roboshop-ShellScript/cart.service /etc/systemd/system/cart.service &>>$LOG
VALIDATE $? "Copying Cart Service"

systemctl daemon-reload &>>$LOG
VALIDATE $? "daemon-reload"

systemctl enable cart &>>$LOG
VALIDATE $? "Enabled Cart Service"

systemctl start cart &>>$LOG
VALIDATE $? "Started Cart Service"

netstat -lntp
VALIDATE $? "Port Checking"