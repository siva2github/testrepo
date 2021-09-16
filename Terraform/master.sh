#!/bin/bash

HOST=`hostname`

if [ "$HOST" = "Jenkins-Master" ]

then

sudo add-apt-repository main ;

sudo apt-get update -qq ;

sudo apt-get install -y unzip ;

sudo apt-get install -y tree ;

wget https://get.jenkins.io/war-stable/2.289.3/jenkins.war ;

sudo apt-get install -y openjdk-8-jdk openjdk-8-jre ;

sudo apt-get update -qq ;

nohup java -jar jenkins.war &

else

sudo add-apt-repository main ;

sudo apt-get update -qq ;

sudo apt-get install -y openjdk-8-headless openjdk-8-jre ;

sudo apt-get install -y openjdk-8-jdk openjdk-8-jre ;

sudo apt-get install -y python-pip ;

sudo apt-get update -qq ;

sudo apt-get install -y software-properties-common ;

sudo apt-get install -y ansible ;

sudo apt-get install -y maven ;

sudo apt-get install -y docker* ;

sudo service docker start ;

sudo apt-get update ;

sudo apt install -y git-all ;

sudo apt-get install -y apt-transport-https gnupg1 curl ;

sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash ;

fi
