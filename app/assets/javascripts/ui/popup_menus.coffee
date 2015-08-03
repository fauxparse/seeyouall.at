$(document)
  .on "click", ".popup-toggle", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).closest(".popup").toggleClass("open")
  # .on "click", ".popup-menu", (e) ->
  #   e.stopPropagation()
  #   $(e.target).closest(".popup").toggleClass("open")
  .on "click", (e) ->
    $(".popup.open").removeClass("open")
