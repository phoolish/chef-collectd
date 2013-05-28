include_recipe "collectd::client"

bag = node['collectd']['data_bag_name']

node['collectd']['plugins'].each do |instance|
  instance_data = data_bag_item(bag, instance)

  collectd_plugin instance do
    instance_data.each do |attribute, value|
      send(attribute, value) unless attribute == "id"
    end
  end
end
