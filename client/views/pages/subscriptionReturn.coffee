###
    View logic for the home page
###

@ViewSubscription = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: (reason) ->
    i18n.i18nMessages.subscriptionreturn =
      ok1: 
        en: "You now have a premium account !"
        fr: "Vous avez maintenant un compte premium !"
      goback: 
        en: "Go back to your"
        fr: "Retournez à votre"
      dashboard: 
        en: "dashboard"
        fr: "tableau de bord"
      ok2: 
        en: "to access all the awesome features !"
        fr: "pour accéder à toutes les fonctionnalités !"
      notok1: 
        en: "We are sorry, the subscription has been canceled."
        fr: "Nous sommes désolé, votre souscription a été annulée."
      notok2:
        en: "If it isn't normal,"
        fr: "Si ce n'est pas normal,"
      notok3:
        en: "throw me"
        fr: "envoyez moi"
      notok4:
        en: "a line."
        fr: "un message."
      pending1: 
        en: "It seems that there is a little setback..."
        fr: "Il semble y avoir un petit contretemps..."
      pending2: 
        en: "We will investigate the matter as soon as possible."
        fr: "Nous allons inspecter ce problème dès que possible."
      pending3: 
        en: ". Sorry for the delay..."
        fr: ". Désolé pour le retard..."
        
    Template.subscriptionReturn.helpers
      ok: () ->
        return reason is "ok"
      pending: () ->
        return reason is "pending"
        
    Template.subscriptionReturn.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)

    @template = Meteor.render () ->
      return Template.subscriptionReturn()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this
