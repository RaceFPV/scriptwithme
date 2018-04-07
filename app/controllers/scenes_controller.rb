class ScenesController < ApplicationController
  include ScenesHelper
  #FIXME: the skip_before_action shouldnt be required
  skip_before_action  :verify_authenticity_token
  
  
  #redirect to the proper path based on logged in user or not
  def index
      if signed_in?
        if current_user.name != nil
          return redirect_to home_path(current_user.name)
        end
      end
    redirect_to start_path
  end

  #show the current scene
  def show
    #redirect to the waiting for partner screen if we haven't found a partner yet
    if params[:id] == "waiting-partner"
      return redirect_to random_connect_path
    end    
    #find the scene based on the url id parameter
    @scene = Scene.find(params[:id]) rescue nil
    if @scene == nil
      return redirect_to root_path, :flash => {:error => "Error joining scene"}
    end
    #if the scene is closed, redirect the user to the saved scene path
    if @scene.state?(:closed)
      return redirect_to savedscene_path(@scene)
    end
    #if the scene has less than two characters, redirect the user back to the waiting path
    if @scene.characters.count < 2
      return redirect_to waiting_path(@scene), :flash => {:notice => "Partner has not joined yet"}
    end
    #give the current users user_id a variable
    @me = current_character_hash[:user_id]
    #used for new character prompt auto-complete
    @user = User.find(current_character_hash[:user_id])
    #set some variables for the characters, if the variables don't set properly (are nil) redirect to the start screen and notify the user
    #get the first character in the scenes user_id
    first_character_id = @scene.characters.first[:user_id]
    #get the first character in the scenes name
    first_character_name = @scene.characters.first[:nickname]
    #if null or error, redirect back to start
    if first_character_id == nil or first_character_name == nil
      return redirect_to root_path, :flash => {:error => "Something went wrong generating the scene characters, please try again"}
    end
    #get the second character in the scenes user_id
    second_character_id = @scene.characters.second[:user_id]
    #get the second character in the scenes name
    second_character_name = @scene.characters.second[:nickname]
    #if null or error, redirect back to start
    if second_character_id == nil or second_character_name == nil
      return redirect_to root_path, :flash => {:error => "Something went wrong generating the scene characters, please try again"}
    end
    #find out who our partner is based on their user_id found via their character (used for the partner is typing notification)
    if first_character_id == current_character_hash[:user_id]
      @partner = second_character_id
    elsif second_character_id == current_character_hash[:user_id]
      @partner = first_character_id
    end
    @partnerfull = User.find(@partner) rescue nil
    if @partnerfull == nil
      return redirect_to root_path, :flash => {:error => "Something went wrong generating the scene characters, please try again"}
    end
    #set the scene title variable
    @title    = @scene.title
    #set the scene content variable substituting the placeholders for the character names
    @content  = @scene.starter
                .gsub('{{X}}', first_character_name)
                .gsub('{{Y}}', second_character_name)
                .html_safe
    #Specify the available line types that are available for the dropdown menu
    @line_kinds = ["Say", "Narrative", "Cut-to"]
    #get the current live viewer count to display
    @viewercount = @scene.livecount
  end


#used to keep track of the save scene title and id during facebook/twitter signup
def savescenetitle
  #debugging information
  puts "Saving script #{session[:savescriptname]} at #{session[:lastsceneid]} by #{current_character_hash[:user_id]}"
    #set some values for incoming parameters from post ajax
    @scriptname = params[:scriptname]
    @sceneid = params[:id]
    @userid = current_character_hash[:user_id]
    #find out what scene the user came from
    @scene = Scene.find(@sceneid)
    #if the scene script hasn't been saved at all yet
      if @scene[:users] == nil
        @scene[:users] = [{}]
      end
      #if there are already others associated, make sure we aren't one of them
      if @scene[:users].first.include?(@userid)
      else
        #if we aren't, add us to the list of associated users
        @scene[:users].first.merge!(@userid => @scriptname)
      end
    puts "scene saved at #{@sceneid} as #{@scriptname} by #{@userid}"
    #save the scene changes
    @scene.save!
    render :nothing => true
end

#when the user clicks save, have it save before redirecting to their profile
def savescene 
    #find the current scene based on url id
    @scene = Scene.find(params[:id])
    @user = current_user
    #if the user is signed in, associate them with this scene
    #TODO: change this from a serialized thing to a belongs_to association?
    if signed_in?
      #if they are the first one associated with the scene, create the array
      if @scene[:users] == nil
        @scene[:users] = [{current_user.id => params[:savescene][:scriptname]}]
      else
        #if there are already others associated, make sure we aren't one of them
        if @scene[:users].include? current_user.id
        else
        #if we aren't, add us to the list of associated users
        @scene[:users] << {current_user.id => params[:savescene][:scriptname]}
        end
      end
      @scene.save
    end
  return redirect_to saved_user_path(@user), :flash => {:success => "Successfully saved script"}
end

def savedscene
  @scene = Scene.find(params[:id]) rescue nil
  if @scene == nil
    return redirect_to root_path, :flash => {:error => "Unable to locate script"}
  end
      #set some variables
    first_character   = @scene.characters.first.nickname
    second_character  = @scene.characters.second.nickname
  
      #set the scene title variable
    @title    = @scene.title
    #set the scene content variable substituting the placeholders for the character names
    @content  = @scene.starter
                .gsub('{{X}}', first_character)
                .gsub('{{Y}}', second_character)
                .html_safe
end


  # If a user clicks on the 'connect with a friend' option, have them to generate a new scene
  def start_new_scene
    #create the new scene
    @scene = Scene.new(params[:scene])
    #find a scene starter to use
    @starter = Starter.find(Starter.pluck(:id).sample)
    #tie the starter title to the scene title
    @scene[:title] = @starter.title
    #tie the starter content to the scene starter
    @scene[:starter] = @starter.content
    #create the scene character
    @characterme = @scene.characters.new
    #associate the character name to the name from the field the user entered
    @characterme[:nickname] = session[:user]
    @characterme[:user_id] = current_character_hash[:user_id]
    puts "saving new scene for user #{session[:user_id]}"
    #save the newly created scene and character
    if @scene.save & @characterme.save
      return redirect_to waiting_path(@scene.id)
    else
      redirect_to root_path, :flash => {:error => "Error creating scene"}
    end
  end

def start_new_scene_invite
    #create the new scene
    @scene = Scene.new(params[:scene])
    #find a scene starter to use
    @starter = Starter.find(Starter.pluck(:id).sample)
    #tie the starter title to the scene title
    @scene[:title] = @starter.title
    #tie the starter content to the scene starter
    @scene[:starter] = @starter.content
    #create the scene character
    @characterme = @scene.characters.new
    #associate the character name to the name from the field the user entered
    session[:user] = params[:invite][:character]
    @characterme[:nickname] = params[:invite][:character]
    @characterme[:user_id] = current_character_hash[:user_id]
    puts "saving new scene for user #{session[:user_id]}"
       

  #save the newly created scene and character and messsage
if @scene.save & @characterme.save
  #send the invite message
user = User.find_by_name(current_user.name)
newmessage = Messages.new
newmessage[:user_id] = params[:invite][:friend]
newmessage[:from] = "#{user.name} - invite"
  newmessage[:content] = "#{user.name} has invited you to start a new script, #{view_context.link_to('click here to accept!', join_path(@scene.id))}"
newmessage[:read] = false
  if newmessage.save
  flash[:success] = "Sent invite to #{params[:invite][:friend]}"
return redirect_to waiting_invite_path(@scene.id, params[:invite][:friend])
else
  return redirect_to root_path, :flash => {:error => "Error sending invite message"}
end
    else
return redirect_to root_path, :flash => {:error => "Error creating invite scene"}
    end
  end


  def waiting_random
    @scene = Scene.find(params[:id])
    
    
    #change the scene state from waiting to operating by using state_machine gem (see scene.rb) if two characters are present
    if @scene.characters.first.nickname != nil
      @scene.start
    end
    #generate the url that allows the friend to join
    @join_url   = join_url  @scene
    @start_url  = scene_url @scene
  end
  
  def unsave
    @scene = Scene.find(params[:id])
    @user = current_character_hash[:user_id]
    @scene.users.each do |x|
      if x.include?(@user)
        x.delete(@user)
        @scene.save!
      end
    end
  redirect_to root_path, :flash => {:success => "Successfully deleted scene"}
  end
  
  
  private
  
  def correct_user
    @user = User.find(session[:user_id])
    redirect_to(root_url) unless @user == current_user
  end
end
