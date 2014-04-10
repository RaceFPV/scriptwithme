# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  nickname   :string(255)
#  scene_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Character < ActiveRecord::Base
  belongs_to  :scene
  belongs_to  :user
  has_many    :lines
  default_scope -> {order('created_at ASC')}
  attr_accessible :nickname, :user_id
  validates :nickname, presence: true
end
