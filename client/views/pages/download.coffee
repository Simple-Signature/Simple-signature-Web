###
    View logic for the subscription page
###

@ViewDownload = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    i18n.i18nMessages.download =
      recuptitle: 
        en: "Get"
        fr: "Récupérez"
      recupsubtitle: 
        en: "all the campaigns !"
        fr: "toutes les campagnes !"
      recuptext: 
        en: "They will automatically be pushed to your mail application. No more worries about how to use your signature. It all taken care of !"
        fr: "Elles seront automatiquement transmises à votre applications mail. Plus de soucis à propos de comment utiliser sa signature. Tout est automatique !"
      outlook2010: 
        en: "Simple Signature for Outlook 2010"
        fr: "Simple Signature pour Outlook 2010"
      outlook2013: 
        en: "Simple Signature for Outlook 2013"
        fr: "Simple Signature pour Outlook 2013"
      chrome: 
        en: "Simple Signature for Gmail for Chrome"
        fr: "Simple Signature pour Gmail pour Chrome"
      firefox: 
        en: "Simple Signature for Gmail for Firefox"
        fr: "Simple Signature pour Gmail pour Firefox"
      mailapp: 
        en: "Simple Signature for Mail.app"
        fr: "Simple Signature pour Mail.app"
      mac: 
        en: "Simple Signature for Mac"
        fr: "Simple Signature pour Mac"
      windows: 
        en: "Simple Signature for Windows"
        fr: "Simple Signature pour Windows"
        
    Template.download.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)

    @template = Meteor.render () ->
      return Template.download()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this