class App.ActivityType extends Spine.Model
  @configure "ActivityType", "name", "plural", "color_name"
  @extend Spine.Model.Ajax

  toString: -> @name

  color: ->
    if @color_name
      Color.named(@color_name)
    else
      Color.pickWithInteger(@id + 4)
