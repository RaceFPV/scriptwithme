class UsersController < ApplicationController
	#FIXME
  skip_before_filter :verify_authenticity_token
  before_action :correct_user, only: [:edit, :home, :friends, :saved, :showprofile, :index]
  before_action :is_admin, only: [:admin, :delete_user, :delete_scene]
	
  def index
	end
	
	def sendalert
	  render 'users/sendalert.js.erb'
	end

  #/users/:id
	def show
    #find the user based on the url id
    #make sure the :id doesnt have any dashes
    id = params[:id].gsub("-", " ") 
    @user = User.find_by_name(id) rescue nil
    if @user == nil
      #try to get by id number
      @user = User.find(params[:id].to_i) rescue nil
    end
    #if we can't find the user for some reason, fallback to the root path
    if @user == nil
      return redirect_to root_path, :flash => {:error => "Can't find user"}
    end
    #create a variable for the scenes the user is in
    @userscenes = []
    #get all scenes
    #FIXME: Make this entire section less of a hack job
    @scenes = Scene.all
    #run through each scene
    @scenes.each do |x|
      #make sure that scene has users associated with it and is not nil
      if x.users != nil
        #run through the list of users associated with that scene
        x.users.each do |y|
          #if the current user being shown matches the user associated with that scene, add that scene to the @userscenes variable
          if y.include?(@user.id)
            @userscenes << x
            puts "found scene #{x.id}"
          end
        end
      end
    end
  end
  
  def showprofile
    #find the user based on the url id
    @user ||= User.find_by_name(params[:id])
  end
  
  def home
    #find the user based on the url id
    @user ||= User.find_by_name(params[:id])
  end

	def new
    #create a new variable to hold User params
		@user = User.new
	end


  #when new user form is submitted do this:
	def create
    #take the form parameters and create a new user from them
		@user = User.new(user_params)
    #if the new user saves to the database do this
    if @user.save
      #sign in as the user
			sign_in @user
      #send an alert notice to the user
      flash[:success] = "Welcome to Scriptwith.me, #{@user.name}!"
      #tie the users session to the newly created user account
      session[:user_id] = @user.id
      #redirect the user to their profile
			redirect_to home_path(@user.name)
      #if the user doesnt save to the database, re-show the registration form
		else
			render 'new'
		end
	end
	
	def saved
	  @user ||= User.find_by_name(params[:id])
	  puts "user_id #{@user.id}"
	  #create a variable for the scenes the user is in
    @userscenes = []
    #get all scenes
    #FIXME: Make this entire section less of a hack job
    @scenes = Scene.all
    #run through each scene
    @scenes.each do |x|
      #make sure that scene has users associated with it and is not nil
      if x.users != nil
        #run through the list of users associated with that scene
        x.users.each do |y|
          #if the current user being shown matches the user associated with that scene, add that scene to the @userscenes variable
          if y.include?(@user.id)
            @userscenes << x
            puts "found scene #{x.id}"
          end
        end
      end
    end
	end

	def edit
    #find the user we're editing
		@user = User.find_by_name(params[:id])
	end

	def update
    #find the user we're updating after they submit the edit user page params
    @user = User.find_by_name(params[:id])
    if @user == nil
      #try to find by id if find by name fails
      @user = User.find(current_user.id)
    end
    #if we aren't updating the password, don't ask us about it
    params[:user].delete(:password) if params[:user][:password].blank?
    #updates the password if the password field isn't blank
    if params[:user][:password]
      #find the identity for omniauth
      user_identity = Identity.find_by_email(@user.email)
      #set the identity password to the params from the form
      user_identity.password = params[:user][:password]
      #make sure its confirmed
      user_identity.password_confirmation = params[:user][:password_confirmation]
      #if it saves, keep going through the controller
      if user_identity.save
      #if it doesn't save, flash an error and re-render the page
      else
        flash[:error] = "Error changing password"
        return render 'showprofile'
      end
    end
    #update Identity as well as User model for the username if the form field isn't blank
    if params[:user][:name]
      if @user.provider == "identity"
        #find the identity for the user we are editing
        user_identity = Identity.find_by_email(@user.email)
        #set the user name to the field entry
        user_identity.name = params[:user][:name]
        #if it saves, start trying to save the user field
        if user_identity.save
          #set the user name to the field params
          @user[:name] = params[:user][:name]
          #if the user saves, alert that it was successful and redirect back to the profile page
          if @user.save
            #notify user of the update
			     flash[:success] = "Profile updated"
			     #toss them back to their profile
            return redirect_to user_profile_path(@user.name)
          #if the save fails, warn the user and re-render the page
          else
            flash[:error] = "Username already exists"
        return redirect_to user_profile_path(@user.name)
          end
        else
          flash[:error] = "Username already exists"
        return redirect_to user_profile_path(@user.name)
        end
      else
        @user[:name] = "#{params[:user][:name]}"
        if @user.save
          #notify user of the update
          flash[:success] = "Profile updated"
          #toss them back to their profile
          return redirect_to user_profile_path(@user.name)
          #if the save fails, warn the user and re-render the page
      else
        flash[:error] = "Username already exists"
        return redirect_to user_profile_path(@user.name)
      end
      end
    end
      #save our changes to the user model
      if @user.update_attributes(params[:user].permit(:name, :password, :location, :favmovie, :favactor, :about))
        #notify user of the update
			  flash[:success] = "Profile updated"
			  #toss them back to their profile
        return redirect_to user_profile_path(@user.name)
		  else
        flash[:error] = "Username already exists"
        return redirect_to user_profile_path(@user.name)
		  end
	end

  def rating
    user = User.find_by_name(params[:id])
    puts "found user #{user.name}"
    rating = params[:rating]
    puts "found rating of #{rating}"
    ratedby = params[:ratedby]
    puts "rated by #{ratedby}"
    if user.rating != nil and user.rating.first.key?(ratedby) == true
      #return render nothing: true
    end
    if user[:rating] == nil
      user[:rating] = [{}]
    end
    puts "saved as #{ratedby} => #{rating}"
    user[:rating].first.merge!("#{ratedby}" => "#{rating}")
    user.save!
    return render nothing: true
  end

  def addfriend
    #make sure we can't add users that don't exist, or add ourselves as a friend, or add a blank/nil name
    if User.where("name = ?", "#{params[:addfriend][:friendname]}") == nil or params[:addfriend][:friendname] == params[:id] or User.find_by_name(params[:id]) == nil or User.find_by_name(params[:id]) == ""
      puts "friend doesn't exist or is self"
      return render 'layouts/friends/error.js.erb'
    end
    if Friends.where("user_id = ? AND friend = ?", "#{params[:id]}", "#{params[:addfriend][:friendname]}").count > 0
      puts "friend already added"
      return render 'layouts/friends/error.js.erb'
    end
    user = User.find_by_name(params[:id])
    newfriend = Friends.new
    newfriend[:user_id] = params[:id]
    newfriend[:friend] = params[:addfriend][:friendname]
    if newfriend.save
      return render 'layouts/friends/added.js.erb'
    else
      puts "error saving friend"
      return render 'layouts/friends/error.js.erb'
    end
  end

def sendmessage
    #make sure we can't add users that don't exist, or add ourselves as a friend, or add a blank/nil name
  if User.where("name = ?", "#{params[:sendmessage][:friendname]}") == nil or params[:sendmessage][:friendname] == User.find_by_name(params[:id]) or User.find_by_name(params[:id]) == nil or User.find_by_name(params[:id]) == ""
      puts "friend doesn't exist or is self"
      return render 'layouts/messages/senderror.js.erb'
    end
if params[:sendmessage][:message] == nil or params[:sendmessage][:message] == ""
  puts "blank message"
  return render 'layouts/messages/senderror.js.erb'
end
    user = User.find_by_name(params[:id])
friend = User.find_by_name(params[:sendmessage][:friendname])
newmessage = Messages.new
newmessage[:user_id] = friend.name
newmessage[:from] = user.name
newmessage[:content] = params[:sendmessage][:message]
newmessage[:read] = false
if newmessage.save
      return render 'layouts/messages/sendsuccess.js.erb'
    else
  puts "error saving message"
      return render 'layouts/messages/senderror.js.erb'
    end
  end

def message
  user = User.find_by_name(params[:id])
  message = Messages.find_by_id(params[:messageid])
  message[:read] = true
  message.save!
  @content = message.content
  @from = message.from
end

def messages
  user = User.find_by_name(params[:id])
  @messages = User.messages?(user.name)
end


  #for user sign_out
	def destroy
		User.find_by_name(params[:id]).destroy
    flash[:success] = "Signed out"
		redirect_to root_path
	end
	
  def delete_user
    @user ||= User.find_by_name(params[:id])
    userdelete = User.find_by_name(params[:delete])
    if userdelete != nil and userdelete.provider == "identity"
      Identity.find_by_email(userdelete.email).destroy
    end
    userdelete.destroy
    flash[:success] = "User deleted"
    redirect_to admin_user_path(@user.name)
  end

  def delete_scene
    @user ||= User.find_by_name(params[:id])
    scenedelete = Scene.find(params[:delete]).destroy
    flash[:success] = "Scene deleted"
    redirect_to admin_user_path(@user.name)
  end
  
  def delete_starter
    @user ||= User.find(params[:id])
    starterdelete = Starter.find(params[:delete]).destroy
    flash[:success] = "Starter deleted"
    redirect_to admin_user_path(@user.name)
  end
	  
  def friends
    @user = User.find_by_name(params[:id])
  end

  def admin
    @user ||= User.find_by_name(params[:id])   
    @users = User.all
    @scenes = Scene.all
    @starters = Starter.all
  end

  def starters
    @user ||= User.find_by_name(params[:id])
    @starter = Starter.new
  end

  def savestarter
    @user ||= User.find_by_name(params[:id])
    @starter = Starter.new
    @starter[:title] = params[:starter][:startertitle]
    @starter[:content] = params[:starter][:startercontent]
    if @starter.save
      flash[:success] = "Starter created"
      return redirect_to starters_path(@user.name) 
    else
      flash[:error] = "Error creating starter"
      return redirect_to starters_path(@user.name)
    end
  end

  def addstarter
    @user = User.find_by_name(params[:id])
    @starter = Starter.new
    @starter[:title] = params[:starter][:title]
    @starter[:content] = params[:starter][:content]
    if @starter.save
      return redirect_to admin_user_path(@user), :flash => {:success => "Added new starter"}
    else
      return redirect_to admin_user_path(@user), :flash => {:error => "Failed to add starter"}
    end
  end

  def adminify
    @user = User.find(params[:user].to_i)
    @me = User.find(params[:id])
    if @me.admin == true
      @user[:admin] = true
      @user.save!
      return redirect_to admin_user_path(@me), :flash => {:success => "Made #{@user.name} an admin"}
    end
  end

def noadmin
    @user = User.find(params[:user].to_i)
    @me = User.find(params[:id])
    if @me.admin == true
      @user[:admin] = false
      @user.save!
      return redirect_to admin_user_path(@me), :flash => {:success => "Revoked #{@user.name}'s admin rights"}
    end
end


	private

  #parameters for the new user form
	def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	# Before filters
	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in."
		end
	end

	def correct_user
		@user = User.find_by_name(params[:id]) rescue nil
		if @user == nil
		  return redirect_to root_path
		end
		redirect_to root_path, notice: "Incorrect user" unless @user.id == session[:user_id]
	end

def is_admin
  	@user ||= User.find_by_name(params[:id]) rescue nil
		if @user == nil
      return redirect_to root_path, notice: "Not an admin"
		end
    redirect_to(root_url) unless @user.admin == true
  end
end
