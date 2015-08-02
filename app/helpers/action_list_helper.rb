module ActionListHelper
  def action_list(options = {}, &block)
    add_class(options, "action-list")
    content_tag :ul, options do
      yield if block_given?
    end
  end

  def action_list_item(text, link, icon = nil, options = {})
    link = link_to(link, options) do
      concat icon(icon)
      concat content_tag(:span, text)
      concat yield if block_given?
    end

    content_tag :li do
      concat link
    end
  end
end
