module ApplicationHelper
  
    # for pretty alert messages using the flash command
   def bootstrap_class_for flash_type
    case flash_type
    when :success
    "alert-success"
    when :error
    "alert-danger"
    when :alert
    "alert-danger"
    when :notice
    "alert-info"
    when :warning
    "alert-warning"
    else
    flash_type.to_s
end
end

 #for gravatar
 
  def avatar_url(user)
    if user.image.present?
      user.image
    else
      default_url = "http://scriptwith.me/clapper3.png"
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=45&d=#{CGI.escape(default_url)}"
    end
  end
end
