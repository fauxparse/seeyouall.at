class App.EventEditor extends Spine.Controller
  elements:
    "[name=\"event[slug]\"]": "slug"
    "header [rel=\"save\"]": "saveButton"

  events:
    "input :input": "scheduleCheck"
    "change :input": "scheduleCheck"
    "input [name=\"event[slug]\"]": "slugChanged"
    "click header .tabs a": "tabClicked"
    "click header [rel=\"save\"]": "save"

  init: ->
    @el.addClass("event-editor")
    @scheduleCheck()
    @_slugChanged = !@event().isNew()
    @$("header .tabs li:first-child a").click()

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
      @$("[rel=\"#{key}\"]")
        .addClass("has-errors")
        .append((@renderErrorMessage(error) for error in errors))
    @saveButton.prop("disabled", !$.isEmptyObject(data.errors))

  save: (e) ->
    e.preventDefault()
    event = @event().load(@json())
    delete event.slug unless @_slugChanged
    event.save()

  renderErrorMessage: (message) ->
    $("<div>", class: "error-message", text: message)

  event: ->
    unless @_event
      @_event = App.Event.refresh(id: $("[name=event_id]").val())[0]
    @_event

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

    @$(":input:not([type=checkbox]):not([type=number])").each ->
      values[@name] ||= $(this).val()

    json = {}
    for own key, value of values
      setJSONValue(json, key.replace(/^[^\[]+\[|\]$/g, "").split("]["), value)
    json

  tabClicked: (e) ->
    e.preventDefault()
    a = $(e.target).closest("a")
    a.closest("li")
      .add(@$(a.attr("href")))
      .addClass("selected")
      .siblings(".selected").removeClass("selected").end()

setJSONValue = (root, parts, value) ->
  key = parts.shift()
  if parts.length
    root[key] = root[key] || {}
    setJSONValue(root[key], parts, value)
  else
    root[key] = value

$ ->
  $(".event-editor").each ->
    new App.EventEditor(el: this)
