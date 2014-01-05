###
    View logic for the header component
###

@ViewHeader = Backbone.View.extend

  template: null

  # Attributes for rendering the root element
  tagName: "div"
  id: "header"

  initialize: () ->
    me = @    
      
    @template = Meteor.render () ->

      return Template.componentHeader()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this
    
Template.componentHeader.events
      # Prevent the page reloading for links
  "click a": (e) ->
    App.router.aReplace(e)
    
Template.componentHeader.helpers
  loggedIn: -> return Meteor.userId()?