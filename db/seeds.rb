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

topics = ['sports', 'dating', 'travel', 'food', 'hobbies', 'world news', 'career', 'education', 'art', 'health', 'technology', 'daily life and routines', 'environmental']
topics.each do |topic|
  Topic.find_or_create_by(name: topic)
end

languages = Constants::LANGUAGE_CODES

languages.each do |language|
  Language.find_or_create_by(code: language[0], name: language[1])
end

language = Language.find_by(code: 'en')
passage = Passage.find_or_create_by(title: "Caring for Our Environment", difficulty: :a1)
sentence_params = [
  "We live on Earth.",
  "Our Earth is very beautiful.",
  "It has green trees and blue skies.",
  "We need to take care of our Earth.",
  "We can recycle and reduce waste.",
  "Let's all do our part to keep Earth clean."
]

translation_params = [
  "Vivimos en la Tierra.",
  "Nuestra Tierra es muy hermosa.",
  "Tiene árboles verdes y cielos azules.",
  "Necesitamos cuidar de nuestra Tierra.",
  "Podemos reciclar y reducir los residuos.",
  "Hagamos todos nuestra parte para mantener la Tierra limpia."
]

sentence_params.each_with_index do |sp, idx|
  sentence = Sentence.find_or_create_by(language: language, order_idx: idx)
  passage.sentences << sentence
  sentence.translations.find_or_create_by(language: language, text: translation_params[idx])
end

Seeds::TtsVoicesService.call
