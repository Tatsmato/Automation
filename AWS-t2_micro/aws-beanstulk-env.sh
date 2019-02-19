#!/bin/bash
#
# Check elasticbeanstalk cname
aws elasticbeanstalk check-dns-availability --cname-prefix my-cname
# create Elastic Beanstalk bucket in Amazon S3 if you don't have
#aws s3api create-bucket --bucket bucket-name --acl public read--region eu-west-3
#or
#aws s3 mb s3://mybucket-name
# UPLOAD your APPlication source bundle to AmazonS3
aws s3 cp mysource-app.zip s3://mybucket-name/my-app/mysource-app.zip

# Create application
aws elasticbeanstalk create-application --application-name my-app --description "description"
# Create the application verion 
aws elasticbeanstalk create-application-version --application-name my-app --version-label v1 --description myappv1 --source-bundle S3Bucket="mybucket-name",S3Key="bucket-file-key" --auto-create-application

# platform-versions: https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.java
aws elasticbeanstalk create-configuration-template --application-name testgl-app --template-name v1 --solution-stack-name "platform-version"

# create environment
aws elasticbeanstalk create-environment --cname-prefix my-cname --application-name my-app --template-name v1 --version-label v1 --environment-name env-name
# Determine if the new environment is Green and Ready.
aws elasticbeanstalk describe-environments --environment-names env-name
