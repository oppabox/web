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

Box.all.each do |b|
  0.upto(3) do 
    i = Item.new
    i.box = b
    i.display_name = Array.new(5){ ('a'..'z').to_a.sample}.join
    i.path = i.display_name
    i.save
  end
end
