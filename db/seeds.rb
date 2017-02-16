# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# default Questions
skills = ['html', 'css', 'js', 'ror', 'db', 'any other programming language']
skills.each { |skill| Question.create(text: "How well do you know #{skill}?") }
