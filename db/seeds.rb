# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_role = Role.find_or_create_by(name: :admin)
super_admin = Role.find_or_create_by(name: :super_admin)

super_admin_user = User.find_or_create_by(email: 'jin@jinz.co') do |user|
  user.password = "password"
  user.username = "jin"
end
UserRole.find_or_create_by(user: super_admin_user, role: super_admin)

admin_user = User.find_or_create_by(email: 'admin@jinz.co') do |user|
  user.password = "password"
  user.username = "admin"
end
UserRole.find_or_create_by(user: admin_user, role: admin_role)

regular_user = User.find_or_create_by(email: 'reg@jinz.co') do |user|
  user.password = "password"
  user.username = "reg"
end

languages = Constants::LANGUAGE_CODES

languages.each do |language|
  Language.find_or_create_by(code: language[0], name: language[1])
end

Difficulty.create([
  { name: "basic", level: 0 },
  { name: "a1", level: 1 },
  { name: "a2", level: 2 },
  { name: "b1", level: 3 },
  { name: "b2", level: 4 },
  { name: "c1", level: 5 },
  { name: "c2", level: 6 },
  { name: "native", level: 7 }
])

language = Language.find_by(code: 'en')

Seeds::TtsVoicesService.call
