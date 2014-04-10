class LiveController < ApplicationController
  #FIXME
  skip_before_filter  :verify_authenticity_token
  
  #used for /user/:id/live
  #shows all currently available live sessions
  def index
    @user = User.find_by_name(params[:id].to_i)
  end
  
  #used for /live/:id
  #shows the current scene live and adds the current user to the viewer count
  def show
    #find the scene we want to watch
    @scene = Scene.find(params[:id])
    #if we are the first one to start watching, set the live viewer count to 1
    if @scene[:livecount] == nil
      @scene[:livecount] = 0
    end
      @scene[:livecount] = @scene.livecount + 1
    #save our view count addition to the scene database
    @scene.save!
    #set some variables for the scene starter to work properly
    first_character   = @scene.characters.first.nickname
    second_character  = @scene.characters.second.nickname
  
    #set the scene title
    @title    = @scene.title
    #set the scene content variable substituting the placeholders for the character names
    @content  = @scene.starter
                .gsub('{{X}}', first_character)
                .gsub('{{Y}}', second_character)
                .html_safe
    #set the viewer count variable
    @viewercount = @scene.livecount
  end
  
  #used for /live/:id/leave
  #remove us from the viewer count if we leave the live script view
  def leave
    @scene = Scene.find(params[:id])
    @scene[:livecount] = @scene.livecount - 1 unless @scene.livecount < 1
    @scene.save!
    @viewercount = @scene.livecount
    #broadcast our change to faye/private_pub
    render partial: 'live/update.js.erb'
  end
end