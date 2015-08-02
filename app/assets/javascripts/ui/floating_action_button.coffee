$(document)
  .on "click", ".floating-action-button", (e) ->
    e.preventDefault()
    $(e.target).closest(".floating-action-button").toggleClass("open")
