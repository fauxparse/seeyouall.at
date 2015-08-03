$(document)
  .on "click", ".floating-action-button", (e) ->
    e.preventDefault()
    ui = $(e.target).closest(".floating-action-button")
    ui.toggleClass("open") if ui.hasClass("open") || $(e.target).closest("button").length
