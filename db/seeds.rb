# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

scene_starters = [
  {
    title: %q[EXTERIOR - Old Castle Grounds],
    content: %q[{{X}} slowly walks the grounds of his castle, his crown and clothing shining in the sunlight. Suddenly {{Y}} comes riding up on his noble steed, stopping {{X}} in his steps. {{Y}} appears very out of breath] 
  },
  {
    title: %q[NIGHT -- Cabin],
    content: %q[{{X}} sleeps on a tattered armchair in the corner. The last embers smolder in the fireplace as the room darkens. Outside the wind howls as a barren tree taps on the window. {{Y}} runs into the room and jolts {{X}} awake.]
    },
  {
    title: %q[INTERIOR -- School],
    content: %q[{{X}} writes on the chalkboard, the class behind them. It's almost time for the class to end, when {{X}} feels something hit them in the back of the head. Whirling around, {{X}} sees {{Y}} trying to look innocent at the back of the room.] 
    },
    {
    title: %q[INTERIOR -- Hospital],
    content: %q[{{X}} paces anxiously outside a hospital room, looking back and forth frantically, when {{Y}} comes around the corner with a look of fear on their face.] 
    },
      {
        title: %q[EXTERIOR NIGHT -- City Street],
    content: %q[{{X}} comes bolting along the road when they run head first into {{Y}} as they come around the corner, dropping what they were carrying. {{Y}} appears anxious and keeps looking over their shoulder while frantically searching for their dropped package.] 
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

