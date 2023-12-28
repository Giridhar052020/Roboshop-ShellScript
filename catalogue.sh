#!/bin/bash
# Installing Catalogue role on Roboshop Project

ID=$(Id -u)
TIMESTAMP=$(date +%F-%X)
LOG="/tmp/$0::$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
P="\e[35m"
N="\e[0m"

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 .....$G Success $N"
    else
        echo -e "$2 .....$R FAILIURE $N"
        exit 1
    fi # END Condition
}

if [ $ID -eq 0 ]
then
    echo -e "$G .. You are root user $N"
else 
    echo -e "$R Failure :: You are not root user $N"
    exit 1
fi # END Condition

dnf module disable nodejs -y &>>$LOG

VALIDATE $? "Module Disabled"

dnf module enable nodejs:18 -y &>>$LOG

VALIDATE $? "Enabled NodeJs"

dnf install nodejs -y &>>$LOG

VALIDATE $? "NodeJS Installation"

id roboshop &>>$LOG # User account

if [ $? -eq 0 ]
then
    echo -e "$Y ::: Roboshop user already created :: $P Skipping $N"
else 
    useradd roboshop
    VALIDATE $? "User account Created"
fi # END Condition

mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOG

cd /app 

unzip -o /tmp/catalogue.zip &>>$LOG
VALIDATE $? "Extracting the catalogue"

npm install &>>$LOG
VALIDATE $? "Installing Dependices"

cp /home/centos/Roboshop-ShellScript/catalogue.service /etc/systemd/system/catalogue.service &>>$LOG

VALIDATE $? "Copying the catalogue service file"

systemctl daemon-reload &>>$LOG
VALIDATE $? "daemon-reload"

systemctl enable catalogue &>>$LOG
VALIDATE $? "Enabled Catalogue Service"

systemctl start catalogue &>>$LOG
VALIDATE $? "Started Catalogue Service"

# We need to install the MONGODB Client and load the Schema.

cp /home/centos/Roboshop-ShellScript/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG

dnf install mongodb-org-shell -y &>>$LOG
VALIDATE $? "Installing MongoDB client"

#LOAD SCHEMA

mongo --host monogodb.maramdevops.online </app/schema/catalogue.js &>>$LOG
VALIDATE $? "SCHEMA Loaded on Client"

