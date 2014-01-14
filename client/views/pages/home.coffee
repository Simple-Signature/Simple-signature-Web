###
    View logic for the home page
###

@Home = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    i18n.i18nMessages.landing =
      accroche: 
        en: "or how you learned to stop worrying and used your mail signature to communicate !"
        fr: "ou comment vous avez appris à ne plus vous en faire et à utiliser votre signature mail pour communiquer !"
      campaignstitle: 
        en: "Campaigns !"
        fr: "Des Campagnes !"
      campaignssubtitle: 
        en: "Campaigns everywhere !"
        fr: "Des Campagnes de partout!"
      campaignstext: 
        en: "Create campaigns of communication using mail signature. They will automatically be pushed to the mail application of your co-workers (and yours). No more worries about how everyone in your company use their signature."
        fr: "Utiliser les signature mail pour vos campagnes de communication. Elles seront automatiquement transmises aux applications mail de vos collègues (et la votre). Plus de soucis à propos de comment tout le monde dans la boîte utilise sa signature."
      targettitle: 
        en: "Aim"
        fr: "Viser"
      targetsubtitle: 
        en: "at the right target."
        fr: "la bonne cible."
      targettext: 
        en: "Because your co-workers don't really care about your communication (or not ?), Simple Signature checks if the email is for a co-worker or a client and automatically choose the right signature in function."
        fr: "Parce que vos collègues ne sont pas vraiment intéressés par votre communication (ou pas ?), Simple Signature vérifie si l'email est pour un collègue ou un client et adapte la signature en fonction."
      freetitle: 
        en: "Last but not least,"
        fr: "Last but not least,"
      freesubtitle: 
        en: "it's free !"
        fr: "c'est gratuit !"
      freetext: 
        en: "You can use Simple Signature for an unlimited time and if you like it, you can buy me a beer or you can unlock more awesome features for a very small price."
        fr: "Vous pouvez utiliser Simple Signature pour un temps illimité et si vous l'aimez, envisagez de débloquer des fonctionnalités supplémentaires géniales pour un tout petit prix."
      signup:
        en: "Sign Up for free"
        fr: "S'inscrire gratuitement"
      
    Template.landing.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      "click #signup": (e) ->
        Accounts._loginButtonsSession.resetMessages();
        Accounts._loginButtonsSession.set('inSignupFlow', true)
        Accounts._loginButtonsSession.set('inForgotPasswordFlow', false)
        Accounts._loginButtonsSession.set('dropdownVisible', true)
        $('#login').html(Meteor.render(Template._loginButtons));

    @template = Meteor.render () ->
      return Template.landing()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this

Template.landing.rendered = () ->
  $(document).ready () ->
    scrollorama = $.scrollorama
      blocks:'.scrollblock'
      enablePin:false
    scrollorama.animate('#mail1',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail2',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail3',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail4',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail5',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#arrow',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail1',
      duration:700
      property:'right'
      start: -1200
      end: 500
    )
    scrollorama.animate('#mail1',
      duration:700
      property:'top'
      start: -200
      end: 0
    )
    scrollorama.animate('#mail2',
      duration:700
      property:'right'
      start: 500
      end: 200
    )
    scrollorama.animate('#mail2',
      duration:700
      property:'top'
      start: -500
      end: 300
    )
    scrollorama.animate('#mail3',
      delay:300
      duration:400
      property:'right'
      start: 200
      end: 500
    )
    scrollorama.animate('#mail3',
      delay:300
      duration:400
      property:'top'
      start: 200
      end: 320
    )
    scrollorama.animate('#mail4',
      delay:300
      duration:400
      property:'right'
      start: -120
      end: -290
    )
    scrollorama.animate('#mail4',
      delay:300
      duration:400
      property:'top'
      start: -40
      end: -130
    )
    scrollorama.animate('#mail5',
      delay:300
      duration:400
      property:'right'
      start: -300
      end: -100
    )
    scrollorama.animate('#mail5',
      delay:300
      duration:400
      property:'top'
      start: 150
      end: 200
    )
    scrollorama.animate('#arrow',
      duration:500
      property:'top'
      start: 300
      end: 175
    )
    scrollorama.animate('#arrow',
      duration:600
      property:'left'
      start: -600
      end: 145
    )