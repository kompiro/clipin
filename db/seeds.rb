# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w(music article video).each do |tag|
  Tag.find_or_create_by_name(tag)
end

Tag.all.each do |tag|
  tag.user_id = 1
  tag.save
end
Clip.all.each do |clip|
  clip.user_id = 1
  clip.save
end
