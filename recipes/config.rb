logrotate_s3_config node['logrotate-s3']['config_file'] do
  s3_aws_region node['logrotate-s3']['aws_region']
  s3_access_key node['logrotate-s3']['access_key']
  s3_secret_key node['logrotate-s3']['secret_key']
end
