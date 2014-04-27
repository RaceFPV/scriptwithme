class User < ActiveRecord::Base
  has_many :characters
  has_many :scenes, through: :characters
  has_many :messages, dependent: :destroy
  has_many :friends, dependent: :destroy
  validates :name, uniqueness: true #make sure each users name is unique
  validates_length_of :name, :minimum => 3, :maximum => 30
  serialize :rating
	before_create :create_remember_token #before a user has been created, give them a session cookie
  before_save :delete_old_users #before saving the new user, prune the database of old users
  attr_accessor :scriptname, :password #no longer used?????

  def slug # Convert user's name to friently url format
    name.gsub(" ", "-")  
  end

#---------------- for oauth ------------------
def self.from_omniauth(auth)
  where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
end

def self.create_from_omniauth(auth)
  create! do |user|
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
    user.email = auth["info"]["email"]
    user.image = auth["info"]["image"]
  end
end
#----------------- end of oauth code ---------------

  #show a count of how many users are online
  #check that they have been active in the past 5 minutes
  #and that their account has existed for more than 5 minutes
  def self.online?
    User.where('updated_at > ? AND created_at < ?', 5.minutes.ago, 5.minutes.ago).count
  end
  
  #check if a friend is currently online by inputting their name
  #and seeing if they have been active in the past 5 minutes
  #return true if friend is active, false if not
  def self.friendonline?(name)
    friend = User.find_by_name(name)
    if friend.updated_at >= 5.minutes.ago
      return true
    else
      return false
    end
  end
  
  def self.friends?(user_id)
    myfriends = Friends.where('user_id = ?', "#{user_id}") rescue nil
    myfriendsfinal = []
    myfriends.each do |x|
      myfriendsfinal << User.find_by_name(x.friend)
    end
    return myfriendsfinal
  end
  
  def self.isfriend?(user_id, friend)
    friend = Friends.where('user_id = ? AND friend = ?', "#{user_id}", "#{friend}")
    if friend.count > 0
      return true
    else
      return false
    end
  end
  
  #get an array list of all friends that have been active in the past five minutes
  def self.allfriendsonline?(user_id)
    #get my list of friends
    myfriends = Friends.where('user_id = ?', "#{user_id}") rescue nil
    if myfriends == nil
      return nil
    end
    #set a variable to hold the final list
    friendsonline = []
    #go through the list of friends
    myfriends.each do |x|
      if x.updated_at >= 5.minutes.ago
          #add them to the list
          friendsonline << x
      end
    end
   return friendsonline
  end
  
  def self.messages?(user_id)
    mymessages = Messages.where('user_id = ?', "#{user_id}").order('created_at DESC') rescue nil
    return mymessages
  end
  
  def self.unreadmessages?(user_id)
    mymessages = Messages.where('user_id = ? AND read = ?', "#{user_id}", false).order('created_at DESC') rescue nil
    if mymessages.count != 0
      return true
    else
      return false
    end
  end
  
  #check if a user has been in more than 15 scenes when provided with their user_id
  #return true or false
  def self.starter?(user_id)
    userfound = User.find(user_id)
    if userfound.scenecount != nil and userfound.scenecount > 15
      #change me to true when ready to activate this feature
      #return true
      return false
    else
      return false
    end
    return false
  end
  
  #return a users average rating when provided with their user_id
  def self.rating?(user_id)
    userfound = User.find(user_id)
    finalrating = Float(0)
    if userfound.rating != nil
      userfound.rating.first.each_pair do |x, y|
        finalrating = finalrating + y.to_i
      end
    else
      return nil
    end
    finalrating = finalrating / userfound.rating.first.count
    return finalrating.to_s[0..3]
  end
  
  #find out if a user is a guest by seeing if their email contains the word
  #guest and is an @writethescene.com email address
  def is_guest?
    /guest_(.)*@scriptwith\.me/.match(self.email)
  end
  
  # Change default param for user from id to id-name for friendly urls.
  # When finding in DB, Rails auto calls .to_i on param, which tosses
  # name and doesn't cause any problems in locating user.
  def to_param
    "#{slug}"
  end
  
#----------- used for 'remember me' session cookie -------
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  
  private
  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
#----------- end of 'remember me' session cookie -----------
    
  #check the database for guest users that have not been active for one day
  #and whose accounts are older than two days then deletes said accounts
  def delete_old_users
    delete = User.where('updated_at <= ? AND created_at <= ? AND email LIKE ?', 1.days.ago, 2.days.ago, "%guest%") rescue nil
    if delete != nil
      delete.each do |x|
       x.destroy rescue nil
      end
    end
  end
   
end

