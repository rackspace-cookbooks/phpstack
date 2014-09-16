# Encoding: utf-8

require_relative 'spec_helper'

describe 'phpstack::feature_flags' do
  before { stub_resources }
  let(:chef_run) { ChefSpec::Runner.new(::UBUNTU_OPTS).converge(described_recipe) }
  describe 'if MySQL is disabled(default)' do
    it 'doesn\'t include the mysql_base recipe' do
      expect(chef_run).to_not include_recipe('phpstack::mysql_base')
    end
    it 'doesn\'t include the mysql_master recipe' do
      expect(chef_run).to_not include_recipe('phpstack::mysql_master')
    end
    it 'doesn\'t include the mysql_slave recipe' do
      expect(chef_run).to_not include_recipe('phpstack::mysql_slave')
    end
  end
  describe 'if MySQL is enabled' do
    let(:chef_run) do
      ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
        node.set['phpstack']['flags']['mysql']['enabled'] = true
      end.converge(described_recipe)
    end
    it 'includes the mysql base recipe' do
      expect(chef_run).to include_recipe('phpstack::mysql_base')
    end
    context 'as a standalone node' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['mysql']['enabled'] = true
          node.set['phpstack']['flags']['mysql']['standalone'] = true
        end.converge(described_recipe)
      end
      it 'includes the mysql master recipe' do
        expect(chef_run).to include_recipe('phpstack::mysql_master')
      end
    end
    context 'as a master node' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['mysql']['enabled'] = true
          node.set['phpstack']['flags']['mysql']['master'] = true
        end.converge(described_recipe)
      end
      it 'includes the mysql base recipe' do
        expect(chef_run).to include_recipe('phpstack::mysql_base')
      end
      it 'includes the mysql master recipe' do
        expect(chef_run).to include_recipe('phpstack::mysql_master')
      end
    end
    context 'as a slave node' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['mysql']['enabled'] = true
          node.set['phpstack']['flags']['mysql']['slave'] = true
        end.converge(described_recipe)
      end
      it 'includes the mysql base recipe' do
        expect(chef_run).to include_recipe('phpstack::mysql_base')
      end
      it 'includes the mysql master recipe' do
        expect(chef_run).to include_recipe('phpstack::mysql_slave')
      end
    end
  end
  describe 'if Webserver is disabled(default)' do
    it 'doesn\'t includes the nginx recipe' do
      expect(chef_run).to_not include_recipe('phpstack::nginx')
    end
    it 'doesn\'t includes the apache recipe' do
      expect(chef_run).to_not include_recipe('phpstack::apache')
    end
  end
  describe 'if Application deployment is disabled(default)' do
    it 'doesn\'t includes the application recipe' do
      expect(chef_run).to_not include_recipe('phpstack::application_php')
    end
  end
  context 'if Application deployment is enabled' do
    let(:chef_run) do
      ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
        node.set['phpstack']['flags']['application']['enabled'] = true
        node.set['phpstack']['demo']['enabled'] = true
        node.set['phpstack']['flags']['webserver']['enabled'] = true
        node.set['phpstack']['flags']['webserver']['apache'] = true
      end.converge(described_recipe)
    end
    it 'includes the application recipe' do
      expect(chef_run).to include_recipe('phpstack::application_php')
    end
  end

  describe 'if Webserver is enabled' do
    context 'and apache is enabled' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['webserver']['enabled'] = true
          node.set['phpstack']['flags']['webserver']['apache'] = true
        end.converge(described_recipe)
      end
      it 'includes the apache recipe' do
        expect(chef_run).to include_recipe('phpstack::apache')
      end
      it 'doesn\'t includes the nginx recipe' do
        expect(chef_run).to_not include_recipe('phpstack::nginx')
      end
    end
    context 'and nginx is enabled' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['webserver']['enabled'] = true
          node.set['phpstack']['flags']['webserver']['nginx'] = true
        end.converge(described_recipe)
      end
      it 'includes the nginx recipe' do
        expect(chef_run).to include_recipe('phpstack::nginx')
      end
      it 'doesn\'t includes the apache recipe' do
        expect(chef_run).to_not include_recipe('phpstack::apache')
      end
    end
  end

  describe 'if Monitoring is enabled' do
    context 'and Newrelic is enabled' do
      let(:chef_run) do
        ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.set['phpstack']['flags']['monitoring']['enabled'] = true
          node.set['phpstack']['flags']['monitoring']['newrelic'] = true
        end.converge(described_recipe)
      end
      it 'includes the Newrelic recipe' do
        expect(chef_run).to include_recipe('phpstack::newrelic')
      end
    end
    describe 'and cloud monitoring is enabled' do
      context 'when we install nginx' do
        let(:chef_run) do
          ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
            node.set['phpstack']['demo']['enabled'] = true
            node.set['platformstack']['cloud_monitoring']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['cloudmonitoring'] = true
            node.set['phpstack']['flags']['webserver']['enabled'] = true
            node.set['phpstack']['flags']['webserver']['nginx'] = true
            node.set['phpstack']['webserver'] = 'nginx'
          end.converge(described_recipe)
        end
        it 'deploys cloud-monitoring configuration for HTTP' do
          expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/example.com-http-monitor.yaml')
        end
      end
      context 'when we install apache' do
        let(:chef_run) do
          ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
            node.set['phpstack']['demo']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['cloudmonitoring'] = true
            node.set['phpstack']['flags']['webserver']['enabled'] = true
            node.set['phpstack']['flags']['webserver']['apache'] = true
            node.set['platformstack']['cloud_monitoring']['enabled'] = true
          end.converge(described_recipe)
        end
        it 'deploys cloud-monitoring configuration for HTTP' do
          expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/example.com-http-monitor.yaml')
        end
      end
    end
    describe 'and cloud monitoring is disabled' do
      context 'when we install nginx' do
        let(:chef_run) do
          ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
            node.set['phpstack']['demo']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['cloudmonitoring'] = false
            node.set['phpstack']['flags']['webserver']['enabled'] = true
            node.set['phpstack']['flags']['webserver']['nginx'] = true
            node.set['platformstack']['cloud_monitoring']['enabled'] = true
            node.set['phpstack']['webserver'] = 'nginx'
          end.converge(described_recipe)
        end
        it 'doesn\'t deploy cloud-monitoring configuration for HTTP' do
          expect(chef_run).to_not render_file('/etc/rackspace-monitoring-agent.conf.d/example.com-http-monitor.yaml')
        end
      end
      context 'when we install apache' do
        let(:chef_run) do
          ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
            node.set['phpstack']['demo']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['enabled'] = true
            node.set['phpstack']['flags']['monitoring']['cloudmonitoring'] = false
            node.set['phpstack']['flags']['webserver']['enabled'] = true
            node.set['phpstack']['flags']['webserver']['apache'] = true
            node.set['platformstack']['cloud_monitoring']['enabled'] = true
          end.converge(described_recipe)
        end
        it 'doesn\'t deploy cloud-monitoring configuration for HTTP' do
          expect(chef_run).to_not render_file('/etc/rackspace-monitoring-agent.conf.d/example.com-http-monitor.yaml')
        end
      end
    end
  end
end
