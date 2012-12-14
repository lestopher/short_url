module ApplicationHelper
  def site_name
    return "localhost:3000"
  end

  def current_controller
    params[:controller]
  end

  def current_action
    params[:action]
  end
end
