#
# Cookbook:: logrotate
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'logrotate-s3::config' do
  let(:environment) { 'staging' }
  let(:chef_run) do
    # for a complete list of available platforms and versions see:
    # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
    runner = ChefSpec::ServerRunner.new(step_into: %w(logrotate_s3_file logrotate_s3_config),
                                        platform:  'ubuntu', version: '18.04') do |node, server|
      server.create_environment(environment)
      node.chef_environment = environment

      node.normal['logrotate-s3']['enabled']     = true
      node.normal['logrotate-s3']['config_file'] = '/tmp/foo.config'
      node.normal['logrotate-s3']['aws_region']  = 'us-east-1'
      node.normal['logrotate-s3']['access_key']  = 'AAA'
      node.normal['logrotate-s3']['secret_key']  = 'BBB'
      node.normal['logrotate-s3']['bucket']      = 'logs-rotated'
      node.normal['logrotate-s3']['folder']      = '/'

      node.normal['org'] = 'dev'
    end

    runner.converge(described_recipe)
  end

  before do
    stub_command('test -d /tmp').and_return(true)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
