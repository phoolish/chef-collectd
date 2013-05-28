#
# Cookbook Name:: collectd
# Recipe:: client_graphite
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "collectd::client"

server = nil
if Chef::Config[:solo]
  # Handled below in fall through case
elsif node['graphite']['server_role']
  query = "role:#{node['graphite']['server_role']} AND chef_environment:#{node.chef_environment}"
  search(:node, query) do |n|
    server = n['fqdn']
  end
  Chef::Log.warn("node with role #{node['graphite']['server_role']} not found") unless server
end

server ||= node['graphite']['server_address']
Chef::Log.warn("node.graphite.server_address not set. defaulting to 127.0.0.1") unless server
server ||= "127.0.0.1"

if node['collectd']['version'] =~ /5\.\d+/
  collectd_plugin 'write_graphite' do
    template "write_graphite.conf.erb"
    options({
      :host => server,
      :port => 2003,
      :prefix => node['collectd']['graphite_prefix'],
      :escape_character => "_",
      :store_rates => false
    })
  end
else
  cookbook_file 'carbon_writer_py' do
    source 'carbon_writer.py'
    path   "#{ node['collectd']['plugin_dir'] }/carbon_writer.py"
    owner  'root'
    group  'root'
    mode   0644
  end

  collectd_plugin 'carbon_writer' do
    options :line_receiver_host => server,
      :line_receiver_port => 2003,
      :derive_counters => true,
      :lowercase_metric_names => true,
      :differentiate_counters_over_time => true,
      'TypesDB' => node['collectd']['types_db']
    type 'python'
  end
end
