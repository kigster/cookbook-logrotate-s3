require_relative 'config'

module LogrotateS3Cookbook
  class File < Chef::Resource
    resource_name :logrotate_s3_file

    property :log_name, String, name_property: true
    property :log_dir, String, required: true
    property :log_pattern, [Array, String], default: '*.log'
    property :logrotate_config_dir, String, default: '/etc/logrotate.d'
    property :maxsize, String, default: '100M'
    property :rotate, Integer, default: 2

    property :upload_to_s3, [true, false], default: true

    property :s3_config, String, default: '/etc/logrotate-s3.conf'
    property :s3_folder, [String, nil], default: nil
    property :s3_bucket, String, default: 'logs-rotated'

    property :frequency, String, default: 'daily'
    property :log_config, Hash, default: {}
    property :last_action, [String, nil]
    property :postrotate, [String, nil]

    alias_method :log_patterns, :log_pattern

    DEFAULT_CONFIG ||= {
      'missingok'     => nil,
      'compress'      => nil,
      'notifempty'    => nil,
      'copytruncate'  => nil,
      'sharedscripts' => nil,
      'dateext'       => nil,
      'dateformat'    => '.%Y%m%d.%s',
    }.freeze

    action :run do
      resource = new_resource

      resource.s3_folder ||= "/#{node.environment}/#{node.name}".tr(' ', '-')

      s3_destination = "s3://#{resource.s3_bucket}#{resource.s3_folder}/#{resource.log_name}/"

      Chef::Log.info("logrotate-s3: destination for #{resource.log_name} log is #{s3_destination}")

      node.normal['logrotate-s3']['logs'][resource.log_name] = s3_destination

      config_lines = []

      DEFAULT_CONFIG.merge(resource.log_config).each_pair do |k, v|
        config_line = k + (v ? " #{v}" : '')
        config_lines << config_line
      end

      arguments = {
        resource:       resource,
        log_config:     config_lines.join("\n  "),
        node_name:      node.name,
        s3_destination: s3_destination,
      }

      directory resource.logrotate_config_dir

      # logrotate complains if the directory is world writeable
      directory resource.log_dir do
        mode '0755'
        only_if { ::Dir.exist?(resource.log_dir) }
      end

      template "#{resource.logrotate_config_dir}/#{resource.log_name}" do
        source 'logrotate.erb'
        cookbook 'logrotate-s3'
        variables(**arguments)
      end
    end
  end
end
