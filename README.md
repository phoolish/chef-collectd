# DESCRIPTION #

Configure and install the [collectd](http://collectd.org/) monitoring daemon.

# REQUIREMENTS #

This cookbook has only been tested on Ubuntu 10.04 and 12.04.

The following cookbooks are required:

+ [apt](http://community.opscode.com/cookbooks/apt)
+ [ark](http://community.opscode.com/cookbooks/ark)
+ [build-essential](http://community.opscode.com/cookbooks/build-essential)
+ [logrotate](http://community.opscode.com/cookbooks/logrotate)
+ [runit](http://community.opscode.com/cookbooks/runit)
+ [yum](http://community.opscode.com/cookbooks/yum)

# ATTRIBUTES #

+ collectd.basedir - Base folder for collectd output data.
+ collectd.plugin_dir - Base folder to find plugins.
+ collectd.types_db - Path to the files to read graph type information from.
+ collectd.interval - Time period in seconds to wait between data reads.

# USAGE #

Three main recipes are provided:

+ collectd::client or collectd::default - Install a unconfigured collectd
+ collectd::client_collectd - Install collectd and configure it to send data to a collectd server.
+ collectd::client_graphite - Install collectd and configure it to send data to a carbon server.
+ collectd::server - Install collectd and configure it to recieve data from clients.

The client recipe will use the search index to automatically locate the server hosts, so no manual configuration is required.

## LWRPs ##

A lwrp is included for configuring plugins.

### collectd_plugin ###

You may use the `collectd_plugin` provider to configure and enable collectd plugins.

```ruby
%w(disk entropy memory swap).each do |plug|
  collectd_plugin plug
end

collectd_plugin 'syslog' do
  options :log_level => 'info',
    :notify_level => 'warning'
end

collectd_plugin 'tcpconns' do
  options :listening_ports => true
end

# Taken from https://collectd.org/wiki/index.php/Plugin:Tail#Invalid_SSH_login_attempts
collectd_plugin 'sshd' do
  type 'tail'
  options :file => {
    '/var/log/auth.log' => {
      :instance => 'auth',
      :match => [
        {
          :regex => '\\<sshd[^:]*: Invalid user [^ ]+ from\\>',
          :d_s_type => 'CounterInc',
          :type => 'counter',
          :instance => 'sshd-invalid_user'
        }
      ]
    }
  }
end
```

The `options` hash is converted to collectd-style settings automatically.
Any symbol key will be converted to camel-case. In the above example
`:listening_ports` will be output as the key `ListeningPorts`. If the key is
already a string, this conversion is skipped. If the value is an array, it
will be output as a separate line for each element.

# LICENSE & AUTHORS #

+ Author:: Miah Johnson (<miah@chia-pet.org>)
+ Author:: Phillip Gentry (<phillip@cx.com>)
+ Author:: Noah Kantrowitz (<noah@coderanger.net>)
+ Author:: Scott M. Likens (<scott@likens.us>)

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
