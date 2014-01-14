###
    View logic for the subscription page
###

@ViewSignup = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    i18n.i18nMessages.subscription =
      accroche: 
        en: "or how you learned to stop worrying and used your mail signature to communicate !"
        fr: "or comment vous avez appris à ne plus vous en faire et utiliser votre signature mail pour communiquer !"
      campaignstitle: 
        en: "Campaigns !"
        fr: "Des Campagnes !"
      campaignssubtitle: 
        en: "Campaigns everywhere !"
        fr: "Des Campagnes de partout!"
      campaignstext: 
        en: "With a premium account, you can create an infinite number of campaigns."
        fr: "Avec un compte premium, vous pouvez créer un nombre infini de campagnes."
      targettitle: 
        en: "Aim"
        fr: "Viser"
      targetsubtitle: 
        en: "at the right target."
        fr: "la bonne cible."
      targettext: 
        en: "Because every one in your company doesn't communicate with the same clients, you can create several groups (called services) and assign a campaign to just one or some services."
        fr: "Parce que tout le monde dans la boîte ne communique pas avec les mêmes clients, vous pouvez créer différents groupes (appelé services) et assigner une campagne à juste certains de ces services."
      marketertitle: 
        en: "Marketers,"
        fr: "Marketers,"
      marketersubtitle: 
        en: "Come all aboard !"
        fr: "Montez tous à bord !"
      marketertext: 
        en: "Create Simple Signature accounts for every member of your team to help you with all those campaigns, signatures and services."
        fr: "Créer des comptes Simple Signature pour tous les membres de votre équipe pour qu'ils puissent vous aider à gérer toutes ces campagnes, signatures et services."
      freetitle: 
        en: "Last but not least,"
        fr: "Last but not least,"
      freesubtitle: 
        en: "it's just 20€ !"
        fr: "c'est seulement 20€ !"
      freetext: 
        en: "For only 20€ per month, you will access all those awesome features and help me improve this service to always more awesomeness !"
        fr: "Pour seulement 20€ par mois, vous aurez accès à toutes ces fonctionnalités géniales et m'aiderez à améliorer ce service pour toujours plus de génialité !"
      subscribe:
        en: "Subscribe"
        fr: "Souscrire"
      admin1:
        en: "Your are not the administrator. Please"
        fr: "Vous n'êtes pas un administrateur. S'il vous plait, "
      admin2:
        en: "contact"
        fr: "contactez-le"
      admin3:
        en: "him/her to reactivated the premium account."
        fr: "pour réactivez le compte premium."
        
    Template.subscription.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)

    @template = Meteor.render () ->
      return Template.subscription()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this

Template.subscription.helpers
  firmId: () -> return Meteor.user().profile.firm
  admin: () -> return Meteor.user() && Meteor.user().profile && Meteor.user().profile.admin
  mailAdmin: () -> return Meteor.users.findOne({'profile.firm': Meteor.user().profile.firm, 'profile.admin': true})

Template.subscription.rendered = () ->
  if Meteor.user() && Meteor.user().profile && Meteor.user().profile.paid
    App.navigate("/dashboard", {trigger: true})