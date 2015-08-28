class App.PaymentsEditor extends Spine.Controller
  elements:
    ".table-container": "tableContainer"
    "table": "table"
    "tbody": "list"
    "[rel=approve]": "approveButton"
    "[rel=decline]": "declineButton"
  
  events:
    "click .pagination a": "paginationLinkClicked"
    "change thead [type=checkbox]": "selectAll"
    "change tbody [type=checkbox]": "selectRow"
    "click footer [rel=approve]": "approveSelected"
    "click footer [rel=decline]": "declineSelected"

  init: ->
    @pageLoaded()

  paginationLinkClicked: (e) ->
    e.preventDefault()
    @loadPage($(e.target).closest("a").attr("href"))

  loadPage: (url) ->
    @table.addClass("loading")
    history.pushState({}, "", url)
    @tableContainer.load("#{url} #table", null, @pageLoaded)
      
  pageLoaded: =>
    @refreshElements()
    @updateButtonStates()
    @selectAll(false)
    if !!location.search && !@list.children().length
      query = location.search.replace(/page=\d+(\&)?/g, "")
        .replace(/\?$/, "")
      @loadPage("#{location.pathname}#{query}")
    
  updateButtonStates: ->
    @approveButton.attr("disabled", !@selected(@rowsWithState("pending")).length)
    @declineButton.attr("disabled", !@selected(@rowsWithState("pending")).length)
    
  rowsWithState: (state) ->
    @$("tbody tr[data-state=#{state}]")
    
  selectAll: (e = true) ->
    toggle = if e.preventDefault?
      e.target.checked 
    else
      !!e
    @$("tbody [type=checkbox]").prop("checked", toggle)
    @updateButtonStates()
    
  selectRow: (e) ->
    allSelected = !@unselected().length
    @$("thead [type=checkbox]").prop("checked", allSelected)
    @updateButtonStates()
    
  selected: (rows) ->
    (rows || @$("tbody tr")).has(":checked")
    
  selectedIDs: (rows) ->
    ($(row).data("id") for row in @selected(rows))
    
  unselected: (rows) ->
    (rows || @$("tbody tr")).not(":has(:checked)")
    
  approveSelected: ->
    @withSelected("approve")

  declineSelected: ->
    @withSelected("decline")

  withSelected: (action) ->
    @selected().addClass("loading")
    $.post("#{location.pathname}/#{action}", { payment_ids: @selectedIDs() })
      .done(@processResponse)

  processResponse: (data) =>
    for payment in data
      @$("tr[data-id=#{payment.id}]")
        .attr("data-state", payment.state)
        .find("[rel=state]")
          .text(I18n.t("payments.state.#{payment.state}"))
        .end()
    @$("tr.loading").removeClass("loading")
    @selectAll(false)
  
$ ->
  $(".payments-list").each -> new App.PaymentsEditor(el: this)