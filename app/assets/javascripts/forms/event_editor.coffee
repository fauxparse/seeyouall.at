class App.EventEditor extends Spine.Controller
  elements:
    "[name=\"event[slug]\"]": "slug"

  events:
    "input :input": "scheduleCheck"
    "change :input": "scheduleCheck"
    "input [name=\"event[slug]\"]": "slugChanged"

  init: ->
    @el.addClass("event-editor")
    @scheduleCheck()
    @_slugChanged = !@el.hasClass("new_event")

  slugChanged: ->
    @_slugChanged = true

  scheduleCheck: ->
    clearTimeout(@_checkTimer)
    @_checkTimer = setTimeout(@check, 500)

  check: =>
    @el.addClass("checking")
    event = @event().load(@json())
    delete event.slug unless @_slugChanged
    event.check().done(@processCheckResult)

  processCheckResult: (data) =>
    @$(".has-errors").removeClass("has-errors")
    @$(".error-message").remove()
    @el.removeClass("checking")
    @slug.val(data.slug) if data.slug?
    for own key, errors of data.errors
      @$("[rel=#{key}]")
        .addClass("has-errors")
        .append((@renderErrorMessage(error) for error in errors))

  renderErrorMessage: (message) ->
    $("<div>", class: "error-message", text: message)

  event: ->
    @_event ||= new App.Event()

  json: ->
    values = {}

    @$("[type=checkbox]:not([value])").each ->
      values[@name] = @checked

    @$("[type=checkbox][name$=\"[]\"]").each ->
      name = @name.replace(/\[\]$/, "")
      values[name] or= []
      values[name].push @value if @checked

    @$("input[type=number]").each ->
      values[@name] = parseInt($(this).val())

    @$(":input").each ->
      values[@name] ||= $(this).val()

    json = {}
    for own key, value of values
      setJSONValue(json, key.replace(/^[^\[]+\[|\]$/g, "").split("]["), value)
    json

setJSONValue = (root, parts, value) ->
  key = parts.shift()
  if parts.length
    root[key] = root[key] || {}
    this.setJSONValue(root[key], parts, value)
  else
    root[key] = value

$ ->
  $(".new_event").each ->
    new App.EventEditor(el: this)
