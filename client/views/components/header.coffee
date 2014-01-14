###
    View logic for the header component
###

@ViewHeader = Backbone.View.extend

  template: null

  # Attributes for rendering the root element
  tagName: "div"
  id: "header"

  initialize: () ->
    i18n.i18nMessages.header =
      simplesignature: config.app_name
      campaigns: 
        en: "Campaigns"
        fr: "Campagnes"
      target: 
        en: "Target"
        fr: "Cible"
      free: 
        en: "Free"
        fr: "Gratuit"

    me = @    
      
    @template = Meteor.render () ->

      return Template.componentHeader()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this
    
Template.componentHeader.events
      # Prevent the page reloading for links
  "change #i18nSelect": (e, t) ->
    e.preventDefault()
    if $("#i18nSelect").val() is "FR"
      i18n.setLocale("fr")
    else
      i18n.setLocale("en")
  "click a": (e) ->
    App.router.aReplace(e)
    
Template.componentHeader.helpers
  loggedIn: -> return Meteor.userId()?
  fr: -> return i18n.getLocale() is "fr"