# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.find_by_email('admin@email.com')
unless admin
admin = User.new(email: 'admin@email.com', first_name: 'Inbox', mi: 'B', last_name: 'User', password: 'secret123$', password_confirmation: 'secret123$', gender: 'Male', birthdate: '1983-07-01', role: 'admin')
admin.save
end



homepage = Page.where(is_root: true).first
if homepage.nil?
homepage = Page.create!({title: 'Home', body: '<p>Lorem ipsum dolor sit amet</p>', active: true, is_root: true, is_required: true, created_by: admin.id, last_updated_by: admin.id})
end
contactpage = Page.where(is_contact: true).first
if contactpage.nil?
contactpage = Page.create!({title: 'Contact Us', body: '', active: true, is_contact: true, is_required: true, created_by: admin.id, last_updated_by: admin.id})
end