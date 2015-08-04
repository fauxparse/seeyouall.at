$ ->
  $(document).on "change input", ".floating-label :input", (e) ->
    $(e.target).parent(".floating-label").toggleClass("has-value", !!$(e.target).val())
  $(".floating-label :input").trigger("change")
