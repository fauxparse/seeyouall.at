class PaginatedSerializer < ActiveModel::Serializer::ArraySerializer
  def initialize(object, options={})
    meta_key = options[:meta_key] || :meta
    options[meta_key] ||= {}
    options[meta_key] = {
      current: object.current_page,
      total: object.total_pages,
    }
    super(object, options)
  end
end