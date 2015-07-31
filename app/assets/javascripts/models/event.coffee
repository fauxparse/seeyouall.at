class App.Event extends Spine.Model
  @configure "Event", "name", "slug", "start_date", "end_date"
  @extend Spine.Model.Ajax

  check: ->
    options = $.extend {}, Spine.Ajax.defaults,
      url: App.Event.url() + "/check"
      type: "post"
      contentType: "application/json"
      data: JSON.stringify(@toJSON())

    $.ajax(options)
