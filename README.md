Scriptwith.me
=============

####Using the following gems:

* Faye
* Private_pub
* Bootstrap
* Jquery
* Omniauth
* State machine
* New Relic

=============
####Launch Faye via:

IN PROD:
'''
chmod +x checkfaye.sh
./checkfaye.sh &
'''

IN DEV:
'''
rackup private_pub.ru -s thin -E production -p 8080
'''

=============
Guest users that have not been active for one full day will be automatically deleted from the database

=============
####Administrator status must be manually set in the rails console by issuing the following commands:

'''
RAILS_ENV=production rails c
@user = User.find_by_name("*your username*")
@user.admin = true
@user.save!
'''

=============

###User access basics:

* When a user visits the site, it checks if they have either a session[:user_id] cookie or a session[:guest_user_id] cookie
* If they don't have either they are automatically generated a guest user_id and guest account
* If they do have a session[:guest_user_id] cookie they are tracked as a guest but not signed in
* If they have a session[:user_id] cookie they are automatically logged in as a registered user

============

###User account notes:

* When a user accesses any portion of the site their account is hit with a :touch to update their [:updated_at] information in the DB
* The writers online count is a list of all users that have an [:updated_at] date/time of less than five minutes
* The users account is touched based on their current [:user_id] or [:guest_user_id]


