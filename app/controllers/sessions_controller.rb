class SessionsController < ApplicationController
  
  #FIXME: the skip_before_filter shouldnt be required
  skip_before_action  :verify_authenticity_token
  
  #/start path, seen by new users visiting the site
  def new
    #put the current users session id in the console for debugging purposes
    puts "session id: #{session.id}"
    puts "hash id: #{current_character_hash[:user_id]}"
    session[:user_id] = current_character_hash[:user_id]
    puts "user id: #{session[:user_id]}"
    #used to get most recently used character
    if current_character_hash[:user_id] != nil
      @user = User.find(current_character_hash[:user_id]) rescue nil
    else
      @user = nil
    end
  end

  #used for allowing users to sign in
	def create
    #store the old user_id before the user signs in via omniauth
    olduserid = current_character_hash[:user_id]
    #let the user login using omniauth
		user = User.from_omniauth(env["omniauth.auth"]) rescue nil
		if user == nil
		  return redirect_to root_path, :flash => {:error => "error signing in, please try again with a unique name/email"}
		end
		#change the user_id to the new one gotten by logging in
    session[:user_id] = user.id
    session[:guest_user_id] = nil
    puts "new user id: #{session[:user_id]}"
    puts "old user id: #{olduserid}"
    
    #check if we are saving the script
    
    #query all scenes for scenes containing our old user id
    #FIXME do this properly with sql
    @scenes = Scene.all
    @scenes.each do |x|
      if x and x.users
        if x.users.first.include?(olduserid)
          puts "found #{x.id}"
          @scene = x
        end
      end
    end
    
    if @scene
        #loop through the hash
        @scene.users.first.each_pair do |y, z|
          #if we found our old user_id
          if y == olduserid
            #give the saved title a variable
            @scriptname = z
            #and then delete it from the hash so it doesn't get re-discovered on next save
            @scene.users.first.delete(y)
            end
          end
        end
        
      #if we are saving as a local account for the first time, this param is not nil
      if params[:scriptname] != nil
        #save the script name as a variable
        @scriptname = params[:scriptname]
        #save the scene as a variable
        @scene = Scene.find(params[:scene_id])
        #see if users is empty
        if @scene.users == nil
          #if it is, give it a new hash to save to
          @scene.users = [{}]
        end
      end
        
    
    #if we found the scene, add the new user_id/title to it
    if @scene
      if @scene[:users] == nil
        @scene[:users] = [{}]
      end
      @scene[:users].first.merge!(user.id => @scriptname)
      
      #increase the user scene count if it hasn't been updated ever
      if user.scenecount == nil
        scenecount = 1
        user.update_attributes(:scenecount => scenecount)
      end
      
      #and then save it
      if @scene.save
        return redirect_to saved_user_path(user.name), :flash => {:success => "Successfully saved script"}
      else
        return redirect_to home_path(user.name), :flash => {:error => "error saving script"}
      end
    end
    if user.created_at == user.updated_at
      return redirect_to home_path(user.name), :flash => {:notice => "Welcome to Scriptwith.me, #{user.name}!"}
    end
    #redirect to the users profile page if we dont save anything
    redirect_to home_path(user.name), :flash => {:notice => "Welcome back, #{user.name}!"}
	end
	
	
	
  #no longer used maybe?
	def createomniauth
	  puts "session id: #{session.id}"
  user = User.from_omniauth(env["omniauth.auth"])
  session[:user_id] = user.id
  redirect_to home_path(user), :flash => {:notice => "Welcome back, #{user.name}!"}
	end
  
  #join page for when a friend joins
  def join
    # Find the existing scene
    @scene = Scene.find(params[:scene_id]) rescue nil
    if @scene == nil
      return redirect_to root_path, :flash => {:error => "Could not find scene, please try again"}
    end
    # Find out who our partner is
    @partner = User.find(@scene.characters.first.user_id) rescue nil
    if @partner == nil
      return redirect_to root_path, :flash => {:error => "Could not find partner, please try again"}
    end
    @partnername = @partner.name
    if session[:user_id] != nil
      @user = User.find(session[:user_id])
    end
  end

  #after user submits join form do this:
  def joincreate
    # Find the existing scene
    @scene = Scene.find(params[:scene_id])
    #create the second character for that scene
    @character = @scene.characters.new
    #associate the character name to the name from the field the user entered
    @character[:nickname] = params[:join][:character].upcase
    #tie the session to the current user
    session[:user] = params[:join][:character].upcase
    @character[:user_id] = current_character_hash[:user_id]
    #save the newly generated character
    if @character.save
      # Redirect the joining user to the scene
      return redirect_to scene_path(@scene.id)
    else
      #something bad happened while trying to save, redirect to the start and flash an error
      return redirect_to root_path, :flash => {:error => "Error joining"}
    end
  end

  
  #kill the user session and close the scene
  def destroy
    #find the user and sign them out
    sign_out
    username = session[:user]
    session.destroy
    
    if scene_id = params[:id]
      scene = Scene.find scene_id
      scene.close! unless scene.closed?
      PrivatePub.publish_to "/scenes/#{scene_id}/show", { action: 'quitter', from: username }
    end

    if request.xhr?
      render :nothing => true
    else
      redirect_to root_url
    end
  end
  
  #if the user fails to sign in properly, redirect and alert them
  def failure
    redirect_to root_url, :flash => {:error => "Error logging in"}
  end

end
