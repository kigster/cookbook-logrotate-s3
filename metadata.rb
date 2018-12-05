name 'logrotate-s3'
maintainer 'Konstantin Gredeskoul'
maintainer_email 'kigster@gmail.com'

license 'MIT'

source_url 'https://github.com/kigster/cookbook-logrotate-s3'
issues_url 'https://github.com/kigster/cookbook-logrotate-s3/issues'

description 'Installs/Configures Logrotate to move files to S3'

long_description <<-EOF
  This cookbook configures UNIX utility logrotate so automatically
  rotate log files, and optionally, to upload them to an S3 bucket.
EOF

chef_version '>= 12.1' if respond_to?(:chef_version)

version '0.1.0'

supports 'ubuntu'
