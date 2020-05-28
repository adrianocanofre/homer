#! /bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
aws s3 cp s3://${BUCKET_NAME}/.environment .environment
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
sudo docker pull ${REPOSITORY_URL}:latest
sudo docker run -d -p 80:80 --env-file .environment ${REPOSITORY_URL}:latest
rm .environment
