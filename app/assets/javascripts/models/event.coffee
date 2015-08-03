class App.Event extends Spine.Model
  @configure "Event", "name", "slug", "start_date", "end_date"
  @extend Spine.Model.Ajax

  startDate: (value) ->
    @start_date = value.format("YYYY-MM-DD") if moment.isMoment(value)
    moment(@start_date)

  endDate: (value) ->
    @end_date = value.format("YYYY-MM-DD") if moment.isMoment(value)
    moment(@end_date)

  check: ->
    options = $.extend {}, Spine.Ajax.defaults,
      url: App.Event.url() + "/check"
      type: "post"
      contentType: "application/json"
      data: JSON.stringify(@toJSON())

    $.ajax(options)