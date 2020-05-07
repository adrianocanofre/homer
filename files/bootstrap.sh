#! /bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
echo "ENVIRONMENT=production" >> .environment-example
echo "SERVICE_NAME=flask-template" >> .environment-example
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 893378221125.dkr.ecr.us-east-1.amazonaws.com
sudo docker pull ${REPOSITORY_URL}:latest
sudo docker run -d -p 80:80 --env-file .environment-example ${REPOSITORY_URL}:latest
