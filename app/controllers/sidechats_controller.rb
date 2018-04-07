class SidechatsController < ApplicationController
  #FIXME
  skip_before_action  :verify_authenticity_token
  
  def show
    
  end
  
  def submit
    #find the current scene based on url id
    @scene ||= Scene.find(params[:id])
    #give the current user id a variable
    @me ||= current_character_hash[:user_id]
    @username = User.find(@me).name
    @content = params[:sidechatsend][:content]

    #find out if we are writing this scene
    if current_character_hash[:user_id] == @scene.characters.first.user_id or current_character_hash[:user_id] == @scene.characters.second.user_id
      @inscene = true
      #find out who our partner is based on their user_id found via their character (used for the partner is typing notification)
      if @scene.characters.first.user_id == current_character_hash[:user_id]
        @partner = User.find(@scene.characters.second.user_id)
      elsif @scene.characters.second.user_id == current_character_hash[:user_id]
        @partner = User.find(@scene.characters.first.user_id)
      end
    end
    return render 'sidechats/submit'
  end



end