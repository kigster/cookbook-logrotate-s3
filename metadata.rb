name 'logrotate-s3'
maintainer 'Konstantin Gredeskoul'
maintainer_email 'kigster@gmail.com'

license 'MIT'

source_url 'https://github.com/kigster/cookbook-logrotate-s3'
issues_url 'https://github.com/kigster/cookbook-logrotate-s3/issues'

description 'Installs/Configures Logrotate to move files to S3'

long_description <<-EOF
  This cookbook provides two custom resources: one for configuring
  AWS S3 access for log upload, and another for rotating the logs.
EOF

chef_version '>= 12.1' if respond_to?(:chef_version)

version '0.2.1'

supports 'ubuntu'
