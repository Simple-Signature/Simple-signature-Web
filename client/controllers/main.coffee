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

Meteor.autorun () ->
  message = Session.get('displayMessage')
  if (message) 
    console.log(message)
    stringArray = message.split('&amp;')
    ui.notify(stringArray[0], stringArray[1]).effect('slide').closable()
    Session.set('displayMessage', null)