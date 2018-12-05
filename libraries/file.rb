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
    property :s3_folder, String
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
        'dateformat'    => '.%Y%m%d.%s'
    }.freeze

    action :run do
      resource     = new_resource

      resource.s3_folder ||= node.environment

      config_lines = []
      DEFAULT_CONFIG.merge(resource.log_config).each_pair do |k, v|
        config_line = k + (v ? " #{v}" : '')
        config_lines << config_line
      end

      arguments = {
          resource:   resource,
          log_config: config_lines.join("\n  "),
          node_name:  node.name
      }

      directory resource.logrotate_config_dir do
        action :create
        not_if "test -d #{resource.logrotate_config_dir}"
      end

      # logrotate complains if the directory is world writeable
      directory resource.log_dir do
        mode '0755'
        only_if { ::Dir.exist?(resource.log_dir) }
      end

      template "#{resource.logrotate_config_dir}/#{resource.log_name}" do
        source 'logrotate.erb'
        cookbook 'logrotate-s3'
        variables(**arguments)
        only_if { ::Dir.exist?(resource.log_dir) }
      end
    end
  end
end
