class App.Event extends Spine.Model
  @configure "Event", "name", "slug", "description", "start_date", "end_date", "payment_methods", "photo_url"
  @extend Spine.Model.Ajax

  startDate: (value) ->
    @start_date = value.format("YYYY-MM-DD") if moment.isMoment(value)
    moment(@start_date)

  endDate: (value) ->
    @end_date = value.format("YYYY-MM-DD") if moment.isMoment(value)
    moment(@end_date)

  check: ->
    url = App.Event.url() + "#{("/#{@id}" if @id) || ""}/check"
    options = $.extend {}, Spine.Ajax.defaults,
      url: url
      type: "post"
      contentType: "application/json"
      data: JSON.stringify(@toJSON())

    $.ajax(options)

  isNew: ->
    !@id
