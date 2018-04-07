# == Schema Information
#
# Table name: lines
#
#  id           :integer          not null, primary key
#  content      :string(255)
#  kind         :string(255)
#  nickname     :string(50)       # Because character's nickname can be changed.
#  character_id :integer
#  scene_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Line < ActiveRecord::Base
  belongs_to :character
  belongs_to :scene
  validates :content, presence: true
  validates :kind, presence: true
  default_scope -> {order('created_at')}

  #attr_accessible :content, :kind, :nickname
end
