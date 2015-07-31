module PopupMenuHelper
  def popup_menu(label_text, options = {}, &block)
    add_class(options, "popup")

    content_tag :div, options do
      concat popup_menu_toggle(label_text)
      concat content_tag :div, class: "popup-menu", &block
    end
  end

  private

  def popup_menu_toggle(label_text)
    link_to "#", class: "popup-toggle" do
      concat content_tag(:div, label_text, class: "popup-toggle-label")
      concat icon("arrow-drop-down")
    end
  end
end
