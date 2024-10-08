class Scene < ActiveRecord::Base
  include AASM
  has_many  :lines, dependent: :destroy
  has_many  :characters, dependent: :destroy
  serialize :users #allows saving user_id's with titles to scenes letting users save the scene
  before_save :delete_old_scenes #prunes scenes older than 2 days that have not been saved

# Generate random hash string to be used as id
  range = [*'0'..'9']
  before_save { self.id ||= Array.new(8){range.sample}.join }
 
  default_scope -> {order('created_at DESC')} #order scenes by created_at time
  
#-------- Used to keep track of a scenes state using state_machine gem ------
##### FIX ME
  # state_machine :initial => :waiting do
  #   event :start do
  #     transition :waiting => :operating
  #   end

  #   event :close do
  #     transition :operating => :closed
  #   end
  # end
  aasm do
    state :waiting, initial: true
    state :operating
    state :closed

    event :start do
      transitions from: :waiting, to: :operating
    end

    event :close do
      transitions from: :operating, to: :closed
    end
  end
#-------- End of scene state code -----------

#find the first 5 scenes with the highest number of likes
  def self.likes?
    where("(scenes.aasm_state = ?)", "closed").order('scenes.likes DESC').limit(5)
  end
  
#find the first 5 scenes that are currently operating and have been updated in the last 5 minutes
  def self.watchable?
    watchable = where("aasm_state = ? AND created_at > ?", "operating", 45.minutes.ago) rescue nil
    result = []
    if watchable == nil
      return nil
    end
    watchable.each do |x|
      if x != nil and  x.lines.first != nil and x.lines.count > 5 and x.lines.last.created_at > 45.minutes.ago
        result << x
      end
    end
    if result == []
      return nil
    else
      return result[0..5]
    end
  end


  def self.my_current_scenes(user_id)
    Scene.joins("INNER JOIN characters ON characters.scene_id = scenes.id").
    where("(scenes.aasm_state = ?) AND characters.user_id = ? AND scenes.created_at > ?", "waiting", user_id, 10.seconds.ago)
  end

#check if a user has a character by providing the user_id -- NO LONGER USED????
  def has_character?(user_id)
    return false if user_id.blank?
    self.characters.where(:user_id => user_id).count > 0
  end
  
  private
  
  #delete old scenes that have been updated older than one day, have no users saved, and are closed
  def delete_old_scenes
    scenes_to_delete = Scene.where('updated_at <= ?', 1.day.ago)
                            .where(users: nil, aasm_state: 'closed')
  
    scenes_to_delete.each(&:destroy)
  end
end
