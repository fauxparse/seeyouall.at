module TabsHelper
  def tabs(collection, options = {}, &block)
    add_class(options, "tabs")
    content_tag :ul, options do
      collection.each.with_index(&block) if block_given?
    end
  end

  def tab(href, options = {}, &block)
    add_class(options, "selected") if options.delete(:selected)
    content_tag :li, options do
      concat link_to(href, &block)
    end
  end
end
