class App.Dialog extends Spine.Controller
  init: ->
    @el.addClass("dialog").prependTo("body")
    @wrapper = $("<div>", class: "dialog-wrapper")
      .appendTo(@el)
      .on "click", (e) =>
        @cancel() unless $(e.target).parents(".dialog-container").length
    @container = $("<div>", class: "dialog-container")
      .appendTo(@wrapper)
      .on $.support.transitionEnd, (e) -> e.stopPropagation()
    @content = @renderContent().appendTo(@container)
    @footer = @renderFooter().appendTo(@container)
      .on("click", "button[rel]", @buttonClicked)
    @refreshElements()
    @showAutomatically()

  showAutomatically: ->
    setTimeout @show, 0

  show: =>
    @el.addClass("in").one($.support.transitionEnd, @shown)

  shown: =>
    $(document).on("keyup", @keypress)

  hide: ->
    $(document).off("keyup", @keypress)
    @el.removeClass("in").on($.support.transitionEnd, @hidden)

  hidden: =>
    @trigger("hidden")
    @release()

  keypress: (e) =>
    if e.which == 27
      @hide()

  ok: =>
    @trigger("ok")
    @hide()

  cancel: =>
    @trigger("cancel")
    @hide()

  buttonClicked: (e) =>
    @[$(e.target).attr("rel")](e)

  renderContent: ->
    content = $("<div>", class: "dialog-content")

  renderFooter: ->
    footer = $("<footer>", class: "dialog-footer")
      .append($("<button>", rel: "cancel", text: I18n.t("dialog.cancel")))
      .append($("<button>", rel: "ok", text: I18n.t("dialog.ok")))
