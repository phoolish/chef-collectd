#
# Cookbook Name:: collectd
# Recipe:: _install_from_package
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

case node['platform_family']
when 'debian'
  include_recipe "apt"
when 'rhel'
  include_recipe "yum::epel"
  include_recipe "yum"
end

# This is dirty. Race-Conditions suck.
execute 'kill_collectdmon' do
  command 'kill -TERM $(pidof collectdmon)'
  user 'root'
  action :nothing
  retries 6
  only_if "ps aux | grep collectdmo[n]"
end

service 'postinst_collectd_init' do
  service_name 'collectd'
  provider Chef::Provider::Service::Init
  action :nothing
end

package "collectd" do
  package_name "collectd"
  notifies :stop, 'service[postinst_collectd_init]', :immediately
  notifies :disable, 'service[postinst_collectd_init]', :immediately
  notifies :run, 'execute[kill_collectdmon]', :immediately
end
