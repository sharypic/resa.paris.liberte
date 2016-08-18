module ApplicationHelper
  def disable_turbolink_only_on_signin
    if resident_signed_in?
      true
    elsif !current_page?(root_url)
      true
    else
      false
    end
  end
end
