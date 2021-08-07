#!/bin/bash
sudo apt-get update -y && sudo apt-get install -f
sudo apt-get update -y && sudo apt upgrade -y
sudo apt-get install nginx -y
sudo systemctl start nginx
MYIP=`ifconfig | grep inet | awk 'NR==1, NR==1 {print$2}'`
sudo mkdir -p /var/www/html
sudo cd /var/www/html
sudo touch index.html
sudo chmod 777 -R /var/www/html/index.html
echo 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html


################################################
#####################################################installing java#####################################################
sudo apt-get install -y openjdk-8-jdk openjdk-8-jre

sudo chmod 777 /etc/environment
java_path=`sudo update-java-alternatives -l | grep java | awk '/java/ {print $3}'`

jre_path=`sudo update-java-alternatives -l | grep java | awk '/java/ {print $3}'`/jre

cat >> /etc/environment <<EOL
JAVA_HOME=$java_path
JRE_HOME=$jre_path
EOL


#####################################################################################################installing jenkins#####################################################
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo chmod 777 /etc/apt/sources.list.d
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins

##########installing maven##################
sudo apt-get install -y maven

############################################


###########################################################################################installing docker###############################################################
#Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

#Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#set up the stable repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo "docker installation done."

###########################################################################################################################################################################
###########################################################################################################################################################################

status=`sudo systemctl status jenkins | grep Active | awk '/Active/ {print$2}'`
if [ "$status" = "inactive" ];then
  sudo systemctl start jenkins
  echo "starting"
fi
status=`sudo systemctl status jenkins | grep Active | awk '/Active/ {print$2}'`
if [ "$status" = "active" ];then
  echo "jenkins services are currently" $status"."
fi
