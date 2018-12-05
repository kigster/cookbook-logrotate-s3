# Example of how nginx logs could be rotated out.
logrotate_s3_file 'nginx' do
  log_dir '/var/log/nginx'
  rotate 5
  s3_bucket 'rotated-logs'
  upload_to_s3 true
end
