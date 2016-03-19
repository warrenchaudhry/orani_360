# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.new email: 'admin@email.com', first_name: 'Warren', last_name: 'Chaudhry', password: 'secret123$', password_confirmation: 'secret123$', gender: 'Male'
u.save
u.reload
u.add_role(:admin)
