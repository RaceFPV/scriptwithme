
class Starter < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true
  validates :title, uniqueness: true
  validates :content, uniqueness: true
  attr_accessible :title, :content
end
