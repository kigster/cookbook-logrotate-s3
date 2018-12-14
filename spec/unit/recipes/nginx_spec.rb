#
# Cookbook:: logrotate
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'logrotate-s3::nginx' do
  let(:environment) { 'staging' }
  let(:config_dir) { '/tmp/logrotate.d' }
  let(:log_dir) { '/tmp/nginx' }
  let(:chef_run) do
    # for a complete list of available platforms and versions see:
    # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
    runner = ChefSpec::ServerRunner.new(step_into: %w(logrotate_s3_file logrotate_s3_config),
                                        platform:  'ubuntu', version: '18.04') do |node, server|
      server.create_environment(environment)
      server.node.chef_environment = environment

      server.node.override['logrotate-s3']['enabled']     = true
      server.node.override['logrotate-s3']['config_file'] = '/tmp/foo.config'
      server.node.override['logrotate-s3']['aws_region']  = 'us-east-1'
      server.node.override['logrotate-s3']['access_key']  = 'AAA'
      server.node.override['logrotate-s3']['secret_key']  = 'BBB'
      server.node.override['logrotate-s3']['bucket']      = 'logs-rotated'
      server.node.override['logrotate-s3']['folder']      = '/'


      server.node.override['logrotate-s3']['nginx']['enabled']              = true
      server.node.override['logrotate-s3']['nginx']['log_dir']              = log_dir
      server.node.override['logrotate-s3']['nginx']['logrotate_config_dir'] = config_dir
      server.node.override['org']                                           = 'dev'
    end

    runner.converge(described_recipe)
  end

  before do
    ::FileUtils.mkdir_p(config_dir)
    ::FileUtils.mkdir_p(log_dir)
  end

  step_into :logrotate_s3_file

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  context 'template' do
    it 'should render template' do
      expect(chef_run).to render_file("#{config_dir}/nginx").with_content(%r{#{log_dir}/\*\.log})
    end
  end
end
