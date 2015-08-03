class App.Dialog extends Spine.Controller
  init: ->
    @el.addClass("dialog").prependTo("body")
    @wrapper = $("<div>", class: "dialog-wrapper")
      .appendTo(@el)
      .on("click", @cancel)
    @container = $("<div>", class: "dialog-container")
      .appendTo(@wrapper)
      .on("click", (e) -> e.stopPropagation())
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

  # TODO dismiss with ESC key
  hide: ->
    @el.removeClass("in").on($.support.transitionEnd, @release)

  ok: =>
    trigger("ok")
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
