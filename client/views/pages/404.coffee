###
    View logic for the home page
###

@ViewNotFound = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
  
    i18n.i18nMessages.notfound =
      oops: 
        en: "Oops !"
        fr: "Oups !"
      notfound:
        en: "404 Not Found"
        fr: "404 Not Found"
      error: 
        en: "Sorry, an error has occurred, Requested page not found !"
        fr: "Désolé, une erreur est apparue, la page demandée n'a pas été trouvée !"
      home: 
        en: "Take Me Home"
        fr: "Ramène moi au début"
      support: 
        en: "Contact Support"
        fr: "Contacte le support"
        
    Meteor.autorun () ->
      loggingIn = Meteor.loggingIn()
      if loggingIn
        Session.set('processLogin', 1)
      else if Session.get('processLogin') is 1
        Session.set('processLogin', 2)
      
    @template = Meteor.render () ->
      return Template.notFound()

    Template.notFound.events
      # Prevent the page reloading for links
      "click": (e) ->
        App.router.aReplace(e)


    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this

Meteor.autorun () ->
  processLogin = Session.get('processLogin')
  if processLogin is 1 
    $('#loading').show();
  else if processLogin is 2
    App.router.navigate("/dashboard", {trigger: true}) 