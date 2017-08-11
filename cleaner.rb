require 'aws-sdk'
require 'awesome_print'

akid = ENV.fetch "AWS_ACCESS_KEY_ID"
secret = ENV.fetch "AWS_SECRET_ACCESS_KEY"
region = ENV.fetch "AWS_DEFAULT_REGION"

Aws.config.update({
  region: region,
  credentials: Aws::Credentials.new(akid, secret),
})

beanstalk = Aws::ElasticBeanstalk::Client.new

resp = beanstalk.describe_applications
resp.applications.each do |app|
  app.versions.each do |version|
    env = beanstalk.describe_environments({
      application_name: app.application_name,
      version_label: version,
    })

    unless env.environments.any?
      ap "There are no apps with version #{version}"
      beanstalk.delete_application_version({
        application_name: app.application_name,
        version_label: version,
        delete_source_bundle: true,
      })
    end

    sleep 1.5
  end
end
