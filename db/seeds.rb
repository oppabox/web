# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

load File.join(File.dirname(__FILE__), '/', 'starbox.rb')
load File.join(File.dirname(__FILE__), '/', 'designbox.rb')
load File.join(File.dirname(__FILE__), '/', 'kitchenbox.rb')
load File.join(File.dirname(__FILE__), '/', 'beautybox.rb')
load File.join(File.dirname(__FILE__), '/', 'grienichbox.rb')
load File.join(File.dirname(__FILE__), '/', 'jewelrybox.rb')

["STAR BOX", "DESIGN BOX", "KITCHEN BOX", "BEAUTY BOX", "GRIENICH BOX", "JEWELRY BOX"].each do |x|
  Box.create(display_name: x, path: x.gsub(" ", "_").downcase )
end

starbox
designbox
kitchenbox
beautybox
grienichbox
jewelrybox
