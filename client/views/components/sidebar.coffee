###
    View logic for the header component
###
    
Template.sidebar.events
      # Prevent the page reloading for links
  "click a": (e) ->
    App.router.aReplace(e)
    
Template.sidebar.helpers
  dashboard: -> return Session.get('sidebar') is "dashboard"
  signatures: -> return Session.get('sidebar') is "signatures"
  campaigns: -> return Session.get('sidebar') is "campaigns"
  images: -> return Session.get('sidebar') is "images"
  users: -> return Session.get('sidebar') is "users"
  services: -> return Session.get('sidebar') is "services"
  admin: -> 
    if Meteor.user()? && Meteor.user().profile?
      return Meteor.user().profile.admin
    else
      return false

i18n.i18nMessages.sidebar =
  dashboard: 
    en: "Dashboard"
    fr: "Tableau de bord"
  signatures: "Signatures"
  campaigns: 
    en: "Campaigns"
    fr: "Campagnes"
  images: 
    en: "Imagery"
    fr: "Images"
  users: 
    en: "Users"
    fr: "Utilisateurs"
  services: "Services"
  download: "App"
  support: "Support"