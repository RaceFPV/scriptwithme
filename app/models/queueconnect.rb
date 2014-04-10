class Queueconnect < ActiveRecord::Base
  default_scope -> {order('created_at ASC')}
  validates :userid, presence: true
  validates :userid, uniqueness: true
  validates :name, presence: true
  
  #Add a user to the queue to randomly connect them
  def self.add(userid, name, rating)
    return if Queueconnect.find_by_userid(userid) != nil
    #find out who we are
    userfull = User.find(userid)
    #find out what our character name is
    charactername = name
    #find out what our rating is, if we dont have one use 0
    myrating = User.rating(userid).to_i rescue 0
    #check if we are a guest or not
    guest = userfull.is_guest?
    #add us to the queue database
      create! do |user|
          user.userid = userfull.id
          user.name = charactername
          user.userrating = myrating
          user.desiredrating = rating
          user.guest = guest
      end
  end
  
  #remove a user from the queue system
  #return true if successfull
  def self.remove(userid)
    connectuser = Queueconnect.find_by_userid(userid)
    if connectuser == nil
      return nil
    end
    if connectuser.destroy
      return true
    else
      return false
    end
  end

#search for a valid partner in the queue system
#return nil if no one is found
def self.search(userid)
  connectuser = Queueconnect.find_by_userid(userid)
  partner = Queueconnect.where('userid != ? AND userrating >= ? AND desiredrating <= ?', userid, connectuser.desiredrating, connectuser.userrating).first rescue nil
  if partner == nil
    return nil
  else
    return partner
  end
end
  
end