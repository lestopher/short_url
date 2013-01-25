module ApplicationHelper
  def site_name
    return root_path
  end

  def current_controller
    params[:controller]
  end

  def current_action
    params[:action]
  end
end
