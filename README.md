# beanstalk-cleaner

Cleans up Application Versions that are not being used by any environment.

### Purpose

Elastic Beanstalk has [service limits](http://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html#limits_elastic_beanstalk) 
which will prevent you from deploying if you have more than 500 versions in your account. This application is meant to be run as a job
that periotically cleans up old versions that are not being used by any environment.

### Setup

This application looks for 3 environment variables in order to access your AWS account:

```
AWS_ACCESS_KEY_ID=myID
AWS_SECRET_ACCESS_KEY=mySecret
AWS_DEFAULT_REGION=us-east-1
```

### Running

You can run this application two ways. You can clone the repository and run 

```bash
bundle exec cleaner.rb
```

Or you can run it using docker by running

```bash
docker run --rm -it \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  zabawaba99/beanstalk-cleaner
```
