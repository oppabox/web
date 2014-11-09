# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["STAR BOX", "JEWELRY BOX", "BEAUTY BOX", "DESIGN BOX", "KTICHEN BOX"].each do |x|
  Box.create(display_name: x, path: x.gsub(" ", "_").downcase )
end
