[![Build Status](https://travis-ci.org/kigster/cookbook-logrotate-s3.svg?branch=master)](https://travis-ci.org/kigster/cookbook-logrotate-s3)

# Cookbook `logrotate-s3` 

This cookbook offers two custom resources that can be used to configure S3 access, and then setup log rotation for any number of log files.

# logrotate

Installs S3 upload script, and offers reusable resource for adding logs to the rotate schedule.

This cookbook uses package `s3cmd` to actually upload gzipped log files that have been rotated by `logrotate`.

## Usage

First we must configure `s3cmd` so that it has access to S3:

### `logrotate_s3_config`

```ruby
logrotate_s3_config '/etc/logrotate-s3.conf' do
  s3_aws_region 'us-east-2'
  s3_access_key 'AFLKJLKJIERFKFJKDJFKDJ'
  s3_secret_key 'fjf09f9gf80ds8fg09f8gdfsg789sdf7'
end
```

### `logrotate_s3_file`

Once configuration is in place, here is how you can wrap a log files produced by `nginx` in a proper rotation schedule, with upload of the gzipped files to S3.

```ruby
logrotate_s3_file 'nginx' do
  s3_config '/etc/logrotate-s3.conf'
  log_dir '/var/log/nginx'
  rotate 5
  s3_bucket 'rotated-logs'
  upload_to_s3 true
end
```

Note that the actual location on S3 will be constructed as 

```
  s3//{{ s3_bucket }}/{{ s3_folder or chef environment }}/nginx/logfile.gz
```  

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kigster/cookbook-logrotate-s3](https://github.com/kigster/cookbook-logrotate-s3).

## License

&copy; 2018 Konstantin Gredeskoul, All rights reserved. MIT License.

## Acknowledgements

 * Jordan Brown @ Homebase

