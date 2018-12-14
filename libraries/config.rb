module LogrotateS3Cookbook
  class Config < Chef::Resource
    resource_name :logrotate_s3_config

    property :config_file, String, name_property: true
    property :enabled, [TrueClass, FalseClass], default: true

    property :s3_aws_region, String, default: 'us-east-1', required: true
    property :s3_access_key, String, required: true
    property :s3_secret_key, String, required: true

    action :run do
      resource   = new_resource
      config_dir = ::File.dirname(resource.config_file)

      directory config_dir

      if resource.enabled && config_dir
        package 's3cmd'

        directory config_dir do
          not_if "test -d #{config_dir}"
        end

        template resource.config_file do
          source 'logrotate_s3_config.erb'
          cookbook 'logrotate-s3'
          variables(
            s3_access_key: resource.s3_access_key,
            s3_secret_key: resource.s3_secret_key,
            s3_aws_region: resource.s3_aws_region
          )
        end
      end
    end
  end
end
