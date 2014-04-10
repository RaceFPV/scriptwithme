module ScenesHelper
  #set a lock variable so that only one user writes to the characters array at a time
  @@lock = Mutex.new
  
  #create the new scene when a match has been found
  #return true if scene was successfully created
  def self.create(me, partner)
        @scene = Scene.new
        #grab a starter for the new users scene
        starter = Starter.find Starter.pluck(:id).sample
        #add the starter info to the scene
        @scene[:title] = starter.title
        @scene[:starter] = starter.content
        #generate the partners character
    partnercharacter = @scene.characters.new
    partnercharacter[:user_id] = partner[:userid]
    partnercharacter[:nickname] = partner[:name]
            #create the scene character
    mecharacter = @scene.characters.new
        #associate the character name to the name from the field the user entered
    mecharacter[:nickname] = me[:name]
    mecharacter[:user_id] = me[:userid]
        #save the newly created scene
    if @scene.save & partnercharacter.save & mecharacter.save 
      return @scene.id
    else
      return false
    end
  end
end