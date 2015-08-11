module SidebarHelper
  def current_user_details
    content_tag :span do
      concat content_tag(:span, current_user.name, class: "name")
      concat content_tag(:email, current_user.email, class: "email")
    end
  end
end
