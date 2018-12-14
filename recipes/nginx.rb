# Example of how nginx logs could be rotated out.
logrotate_s3_file 'nginx' do
  log_dir node['logrotate-s3']['nginx']['log_dir']
  logrotate_config_dir node['logrotate-s3']['nginx']['logrotate_config_dir']
  rotate 5
  s3_bucket 'rotated-logs'
  upload_to_s3 true
  action :run
  only_if { node['logrotate-s3']['nginx']['enabled'] }
end
