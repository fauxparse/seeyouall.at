class App.ActivityType extends Spine.Model
  @configure "ActivityType", "name", "plural"
  @extend Spine.Model.Ajax

  toString: -> @name

  color: ->
    Color.pickWithInteger(@id + 4)
