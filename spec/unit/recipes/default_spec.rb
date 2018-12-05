#
# Cookbook:: logrotate
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'logrotate-s3::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:environment) { 'staging' }
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '18.04') do |node, server|
        server.create_environment(environment)
        node.chef_environment = environment

        node.normal['logrotate-s3']['config_file'] = '/tmp/foo.config'
        node.normal['logrotate-s3']['aws_region']  = 'us-east-2'
        node.normal['logrotate-s3']['access_key']  = 'XXXX'
        node.normal['logrotate-s3']['secret_key']  = 'YYYY'

        node.normal['org'] = 'dev'
      end

      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
