###
    The main entry point for the client side of the app
###

# Create the main app object
@App = {}

Meteor.startup () ->
  Session.set('processLogin', 0)
  Meteor.subscribe('firms')
  App.router = new Router()
  Backbone.history.start({pushState: true})
  Backbone.history.on("route", sendpageview)

Meteor.autorun () ->
  message = Session.get('displayMessage')
  if (message) 
    console.log(message)
    stringArray = message.split('&amp;')
    ui.notify(stringArray[0], stringArray[1]).effect('slide').closable()
    
Handlebars.registerHelper "prettifyDate", (date) ->
  return date.toLocaleDateString() 
  
sendpageview = () ->
  url = Backbone.history.getFragment()
  ga('send', 'pageview', "/#{url}");