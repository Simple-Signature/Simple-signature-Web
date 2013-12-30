###
    The main entry point for the client side of the app
###

# Create the main app object
@App = {}

Meteor.startup () ->
        # Create the backbone router
  Meteor.subscribe('firms')
  App.router = new Router()
  Backbone.history.start({pushState: true})

