require 'aws-sdk'
require 'awesome_print'
require 'time'

akid = ENV.fetch "AWS_ACCESS_KEY_ID"
secret = ENV.fetch "AWS_SECRET_ACCESS_KEY"
region = ENV.fetch "AWS_DEFAULT_REGION"
age = ENV.fetch "AGE_DAYS"

clean_time = Time.now - age.to_i * 86400

Aws.config.update({
  region: region,
  credentials: Aws::Credentials.new(akid, secret),
})

client = Aws::ElasticBeanstalk::Client.new

resp = client.describe_applications
resp.applications.each do |app|
  app.versions.each do |version|
    version_info = client.describe_application_versions({
      application_name: app.application_name,
      version_labels: [version]
    })

    created_date = version_info.application_versions.first.date_created
    if created_date < clean_time
      env = client.describe_environments({
        application_name: app.application_name,
        version_label: version
      })

      unless env.environments.any?
        ap "There are no apps with version #{version}, deleting..."
        client.delete_application_version({
          application_name: app.application_name,
          version_label: version,
          delete_source_bundle: true
        })
      end
    else
      ap "The app (#{app.application_name}) version (#{version}) is not old enough to delete (#{created_date} > #{clean_time})"
    end

    # Sleep to prevent ratelimit
    sleep 1
  end
end
