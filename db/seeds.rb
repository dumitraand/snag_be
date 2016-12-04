# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

super_users = User.where(:role => User::SUPERUSER).all
users = User.where(:role => User::USER).all

@p2 = Project.create(:name => Faker::Superhero.power)
@p1 = Project.create(:name => Faker::Superhero.power)


UserProject.create(:user => super_users.first, :project => @p1)
UserProject.create(:user => super_users.second, :project => @p1)
UserProject.create(:user => users.first, :project => @p1)
UserProject.create(:user => users.second, :project => @p1)

UserProject.create(:user => super_users.first, :project => @p2)
UserProject.create(:user => users.first, :project => @p2)

50.times do
  Issue.create(
    :project => [@p2, @p1].sample,
    :name => Faker::ChuckNorris.fact,
    :priority => (0..5).to_a.sample,
    :issue_code => rand.to_s[2..10],
    :story_points => [1, 2, 3, 5, 8, 13, 21, 34].sample,
    :sprint => (1..3).to_a.sample,
    :label => Faker::Space.moon,
    :description => Faker::Lorem.sentence,
    :environment => ["SCM1", "Local", "VirtualHost", "VirtualBox"].sample,
    :reporter => super_users.first,
    :creation_date => Time.now.to_f
  )
end
