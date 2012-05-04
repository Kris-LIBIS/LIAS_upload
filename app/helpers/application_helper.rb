module ApplicationHelper

  def current_user
    return nil unless (user_id = session[:user_id])
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_user_is_admin?
    user = current_user
    user.nil? ? false : user.admin?
  end

end
