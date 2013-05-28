#
# Cookbook Name:: collectd
# Resource :: plugin
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
def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true

types = %w(plugin python perl exec unixsock java tail)
attribute :type, :kind_of => String, :default => 'plugin', :equal_to => types

attribute :options, :kind_of => Hash
attribute :modules, :kind_of => Hash
attribute :template, :kind_of => String
attribute :source, :kind_of => String
attribute :cookbook, :kind_of => String
