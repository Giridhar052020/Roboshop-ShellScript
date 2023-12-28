#!/bin/bash
# MONGODB Installation with Script

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
        echo -e "$G $2 ... SUCCESS $N"
    else
        echo -e "$R ERROR :: $2 FAILED $N"
        exit 1
    fi # END COndition
}
if [ $ID -eq 0 ]
then
    echo "$G You are the Root User $N"
else
    echo "$R ERROR :: You are not Root User $N"
    exit 1
fi # END Condition

# Install MONGO DB

cp /home/centos/Roboshop-ShellScript/mongo.repo /etc/yum.repo.d/mongo.repo &>>$LOG

dnf install mongodb-org -y  &>>$LOG

VALIDATE $? "Installing MONGODB" 

systemctl enable mongod &>>$LOG

VALIDATE $? "Enabled MonogoDB Service"

systemctl start mongod &>>$LOG

VALIDATE $? "Started MongoDB Service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG

systemctl restart mongod &>>$LOG

VALIDATE $? "Restart MongoDB Service"

