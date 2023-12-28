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
    fi # END COndition
}
if [ $ID -eq 0 ]
then
    echo "$G You are the Root User $N"
else
    echo "$R ERROR :: You are not Root User $N"
fi # END Condition

# Install MONGO DB

cp /home/centos/Roboshop-ShellScript/mongo.repo /etc/yum.repo.d/mongo.repo &>>$LOG

dnf install mongodb-org -y  &>>$LOG
VALIDATE $? "Installing MONGODB" 
