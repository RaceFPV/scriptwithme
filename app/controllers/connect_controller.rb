class ConnectController < ApplicationController
  include ScenesHelper
  #FIXME: the skip_before_filter shouldnt be required
  skip_before_filter  :verify_authenticity_token

  # Page for when a user is waiting for a random partner to connect
  def waiting_random_partner
    #if the character name is blank, redirect and notify the user
    if params[:start_path][:character] == "" or params[:start_path][:character] == nil
      return redirect_to root_path, :flash => {:error => "Character name cannot be blank"}
    end
    #if partner is filtering based on rating store it in a session cookie, if we arent filtering just use 0
    if params[:start_path][:rating] != nil
      rating = params[:start_path][:rating].to_i
      session[:rating] = rating
    else
      session[:rating] = 0
    end
    #keep track of the character name the user entered so we don't lose it when the user is redirected to the scene
    nickname = params[:start_path][:character].upcase
    #by saving it to a new session
    session[:user] = nickname
    #add the user to the queue
    @@lock.synchronize do
      Queueconnect.add(session[:user_id],session[:user],session[:rating])
    end
  end

  # Try to find someone to connect to after a count of 3 seconds on the 'waiting_random_partner' page
  def random_connect
    @@lock.synchronize do
    # First, check if user is randomly selected or not
    scenes = Scene.my_current_scenes(current_character_hash[:user_id]).first rescue nil
    @me = current_character_hash
    #if the user has been selected, toss them a redirect to the newly created scene
    if scenes != nil and scenes.state?(:waiting) and scenes.created_at > 10.seconds.ago
      return render :json => {:scene_url => scene_path(:id => scenes.id)}
    end
      # If user is not selected, then search for a valid partner
      partner = Queueconnect.search(session[:user_id])
      #if a partner has been found create the scene and then remove them and us from the queue
      if partner != nil
        me = Queueconnect.find_by_userid(current_character_hash[:user_id])
        scene = ScenesHelper.create(me, partner)
        if scene == false
          return redirect_to root_path, :flash => {:error => "Error generating scene"}
        end
        Queueconnect.remove(partner.userid)
        Queueconnect.remove(current_character_hash[:user_id])
        return render :json => {:scene_url => scene_path(:id => scene)}
      else
        render :nothing => true
      end
    end
  end
  
    def waiting
    @scene = Scene.find(params[:id])
    #generate the url that allows the friend to join
    @join_url = join_url(@scene)
    @start_url = scene_url(@scene)
    puts "waiting for partner, our user_id is #{session[:user_id]}"
    #if partner joins, send us into the scene
    if @scene.characters.count > 1
      return render :json => {:scene_url => scene_path(:id => @scene.id)}
    end
  end

  def waiting_invite
    @scene = Scene.find(params[:id])
    #generate the url that allows the friend to join
    @join_url = join_url(@scene)
    @start_url = scene_url(@scene)
    @friend = User.find_by_name(params[:friend])
    puts "waiting for #{params[:friend]}, our user_id is #{session[:user_id]}"
    #if partner joins, send us into the scene
    if @scene.characters.count > 1
      return render :json => {:scene_url => scene_path(:id => @scene.id)}
    end
  end


  def invitefriend
    @me = User.find_by_name(current_user.name)
    @friend = User.find_by_name(params[:friend])
  end

# When user leaves the waiting random partner page without connecting to someone else (they closed their browser etc)
# remove them from the queue system
  def giveup
    @@lock.synchronize do
      Queueconnect.remove(current_character_hash[:user_id])
      puts "user gave up searching"
      end
      render :nothing => true
  end
  
  end