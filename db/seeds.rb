# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

scene_starters = [
  {
    title: %q[Title goes here],
    content: %q[{{X}} {{Y}} description goes here.]
  },
  {
    title: %q[Title goes here],
    content: %q[{{X}} {{Y}} description goes here.]
    }
]

pbar = ProgressBar.create( title: 'Seed Scene Starters', total: scene_starters.count, format: '%a |%b>>%i| %p%% %t [%c/%C done]')
scene_starters.each do |starter|
  Starter.create starter
  pbar.increment
end

admin_account_omni = [
    {
    name: %q[Admin],
      email: %q[admin@scriptwith.me],
    password: %q[h@ckp40F],
    password_confirmation: %q[h@ckp40F]
  }
]


pbar = ProgressBar.create( title: 'Seed Admin Omniauth Account', total: admin_account_omni.count, format: '%a |%b>>%i| %p%% %t [%c/%C done]')
admin_account_omni.each do |omni|
  Identity.create omni
  pbar.increment
end

user1 = Identity.find_by_name("Admin")

User.create do |user|
  user.uid = user1["id"]
  user.name = user1["name"]
  user.email = user1["email"]
  user.password_digest = user1.password_digest
  user.provider = "identity"
  user.admin = true
end

