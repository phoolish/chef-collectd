#
# Cookbook Name:: collectd
# Recipe:: client_collectd
#

include_recipe 'collectd::client'

servers = []

if Chef::Config[:solo]
  if node['collectd']['server_address'].nil?
    servers << '127.0.0.1'
  else
    servers << node['collectd']['server_address']
  end
else
  query = "role:#{node['collectd']['server_role']} AND chef_environment:#{node.chef_environment}"
  search(:node, query) do |n|
    servers << n['fqdn']
  end
end

collectd_plugin "network" do
  options :server => servers
  type 'plugin'
end
