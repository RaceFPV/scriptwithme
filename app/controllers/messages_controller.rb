 class MessagesController < ApplicationController
  include ScenesHelper
  #FIXME: the skip_before_filter shouldnt be required
  skip_before_filter  :verify_authenticity_token
   
  # ----------- Used for verification that users are still in a scene -----------
  def leftscene
    #give the current users user_id a variable
    @me ||= session[:user_id]
    render 'scenes/messages/leftscene'
  end
  
  def atscene
    #give the current users user_id a variable
    @me ||= session[:user_id]
    render :nothing => true
  end
  # ----------- End of scene verification --------------
  
  
    #Some info from for chatters, like user1 is typing...
  def info
    @scene = Scene.find(params[:id])
    @me = current_character_hash[:user_id]
    #tie the recieved ajax action to a variable
    action = params[:current_action]
    if action == "typing"
      puts "Line 155 #{action}"
      return render 'scenes/messages/typingnotice'
    else
      puts "Line 155 #{action}"
      return render 'scenes/messages/typingstop'
    end
    render :nothing => true
  end
  
    #User has left the scene
  def leave
    puts "Scene #{params[:id]} has ended because a user has left the scene"
    #find the scene based on its id
    @scene = Scene.find(params[:id])
    @me = current_character_hash[:user_id]
    @user = User.find(current_character_hash[:user_id])
    #increase our scene participation count by one
    if @user.scenecount == nil
      scenecount = 1
      @user.update_attributes(:scenecount => scenecount)
      puts "added scenecount of #{scenecount} for #{@user.name}"
    else
      scenecount = @user.scenecount + 1
      @user.update_attributes(:scenecount => scenecount)
      puts "added scenecount of #{scenecount} for #{@user.name}"
    end
    #find out who our partner is based on their user_id found via their character (used for the partner is typing notification)
    if @scene.characters.first.user_id == current_character_hash[:user_id]
      @partner = User.find(@scene.characters.second.user_id)
    elsif @scene.characters.second.user_id == current_character_hash[:user_id]
      @partner = User.find(@scene.characters.first.user_id)
    end
    #start the scene if it hasnt started already
    if @scene.state?(:waiting)
      @scene.start
    end
  if @scene.state?(:closed) == false
  #notify the partner that the user left the scene via leave.js.erb
    render 'scenes/messages/leave'
  end
  #close the scene
  @scene.close! unless @scene.closed?
  end
  
    #create a new line from the submitted line form
  def drop_a_line
    #find the current scene based on url id
    @scene ||= Scene.find(params[:id])
    #give the current user id a variable
    @me ||= current_character_hash[:user_id]
    #make sure the scene starts when the first line is dropped
    if @scene.state?(:waiting)
      @scene.start
    end
     #get previous lines nickname
     @linecount = @scene.lines.count rescue 0
      if @linecount != 0
        @lastnickname = @scene.lines.last.nickname
      else
        @lastnickname = nil
      end
    #create a new line row and use the drop_a_line params
    @line = Line.new(params[:drop_a_line])
    #set the parameters for the new line
    @line[:nickname] = session[:user]
    @line[:character_id] = current_character_hash[:user_id]
    @line[:scene_id] = @scene.id
    @line[:content] = params[:drop_a_line][:content]
    @line[:kind]  = params[:drop_a_line][:kind]
    #if the line saves, run drop_a_line.js.erb otherwise flash an error
      if @line.save
        @lineid = @line.id.to_s.chomp('?#{@scene.id}')
        return render 'scenes/messages/drop_a_line'
      else
        return render 'scenes/messages/drop_a_line_error'
      end
  end
  
    #change the users character name
  def change_name
    #find the scene based on its id
    @scene ||= Scene.find(params[:id])
    @me ||= current_character_hash[:user_id]
    #find the users original character name
    @original_name = session[:user]
    #if the user is using a name from the dropdown
    if params[:reuse_name] != nil
      @new_name = params[:reuse_name].upcase
      #change the sessions name to the new name
      session[:user] = @new_name
    elsif params[:change_name][:new_name].strip == nil or params[:change_name][:new_name].strip == ""
      return render 'scenes/messages/namechangefailedblank'
      #does not allow character names over a certain length
    elsif params[:change_name][:new_name].length > 35
      return render 'scenes/messages/namechangefailed'
    else
      #if the user didn't change the name, dont do anything
      if session[:user] == params[:change_name][:new_name].upcase
        return render :nothing => true
      end
      #set the users new character name based on the form parameter
      @new_name = params[:change_name][:new_name].upcase
      #create the new character
      character = @scene.characters.new
      #set the characters nickname variable
      character[:nickname] = @new_name
      character[:user_id] = @me
      #save the newly created character
      character.save
      #change the sessions name to the new name
      session[:user] = @new_name
    end
    #put something in console for easy debugging
    puts "Line 259 NAME CHANGED FROM #{@original_name} TO #{@new_name}"
    #render the page that triggers the faye alert
    render 'scenes/messages/namechange'
  end

  def deleteline
    @scene = Scene.find(params[:id])
    #find the line we want to delete, go through the list of lines in the scene
    # and then delete it.
    @line = params[:line]
    @scene.lines.each do |x|
      if x.id.to_s.chomp('?#{@scene.id}') == @line
        #dont let people try and abuse the delete link if they ever find it
        if x.character_id == current_character_hash[:user_id]
         x.destroy
          return render 'scenes/messages/deleteline'
        end
      end
    end
  end


    #when a user ends the scene, let everyone know
  def endscene
    @me = current_character_hash[:user_id]
    @scene = Scene.find(params[:id])
    @user = User.find(current_character_hash[:user_id])
    #find out who our partner is based on their user_id found via their character (used for the partner is typing notification)
    if @scene.characters.first.user_id == current_character_hash[:user_id]
      @partner = User.find(@scene.characters.second.user_id)
    elsif @scene.characters.second.user_id == current_character_hash[:user_id]
      @partner = User.find(@scene.characters.first.user_id)
    end
    if @scene.state?(:closed)
      return  render :nothing => true
    end
    #close the scene by using state_machine gem
    if @scene.state?(:waiting)
      @scene.start
    end
        #increase our scene participation count by one
    if @user.scenecount == nil
      scenecount = 1
      @user.update_attributes(:scenecount => scenecount)
      puts "added scenecount of #{scenecount} for #{@user.name}"
    else
      scenecount = @user.scenecount + 1
      @user.update_attributes(:scenecount => scenecount)
      puts "added scenecount of #{scenecount} for #{@user.name}"
    end
       #increase our partners count by 1
    if @partner.scenecount == nil
      scenecount = 1
      @partner.update_attributes(:scenecount => scenecount)
    else
      scenecount = @partner.scenecount + 1
      @partner.update_attributes(:scenecount => scenecount)
    end
  @scene.close! unless @scene.closed?
  #add some notes to the log
  puts "Scene #{params[:id]} has ended"
  @scene.update_attributes(likes: 1)
  #show the scene_end modal that allows the user to save the scene
  render 'scenes/messages/scene_end'
  end
  
end