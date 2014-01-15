###
    View logic for the Cars page
###

@ViewCampaigns = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
    Session.set('sidebar', 'campaigns')
    
    i18n.i18nMessages.campaigns =
      create: 
        en: "Create a new campaign"
        fr: "Créer une nouvelle campagne"
      new: 
        en: "New Campaign"
        fr: "Nouvelle Campagne"
      title: 
        en: "Campaign's title"
        fr: "Titre de la campagne"
      signature: "Signature"
      service: "Service"
      notify:
        en: "Notify when the campaign begins"
        fr: "Notifier quand la campagne commence"
      createbutton: 
        en: "Create"
        fr: "Créer"
      datedebut:
        en: "Start date"
        fr: "Date de début"
      datefin:
        en: "End date"
        fr: "Date de fin"
      cancel:
        en: "Cancel the campaign"
        fr: "Annuler la campagne"
      alreadySameCampaign:
        en: "Error &amp; A campaign with that title already exists." 
        fr: "Erreur &amp; Une campagne avec ce titre existe déjà."
      empty:
        en: "Error &amp; The name must not be empty." 
        fr: "Erreur &amp; Le nom ne doit pas être vide." 
      upgrade:
        en: "Error &amp; You cannot create more than 3 campaigns at the same time. Please <a href='/subscription'>upgrade your account</a> to do so."
        fr: "Erreur &amp; Vous ne pouvez pas créer plus de 3 campagnes en même temps. Passez à un <a href='/subscription'>compte premium</a> pour le faire."
          
    Template.campaigns.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
 
    @template = Meteor.render () ->
      return Template.campaigns()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this
    
Template.campaigns.admin = () ->
  if Meteor.user()? && Meteor.user().profile?
    return Meteor.user().profile.admin
  else
    return false
    
Template.campaigns.rendered = () -> 
  ModalEffects() 
  $('#calendar').html('')
  $('#calendar').fullCalendar
    events: Campaigns.find({firm: Meteor.user().profile.firm}).fetch()
    eventResize: (campaign, dayDelta,minuteDelta,revertFunc) ->
      if !campaign.end?
        end = campaign.start
        end.setHours(23,59,59,999)
        campaign.end = end
      if Meteor.user().profile.paid or isNotAlreadyThreeCampaigns(campaign.firm, campaign.start, campaign.end, campaign._id)
        Campaigns.update(campaign._id,$set: {end:campaign.end})
      else
        revertFunc()
    eventDrop: (campaign, dayDelta,minuteDelta,allDay,revertFunc) ->
      if !campaign.end?
        end = campaign.start
        end.setHours(23,59,59,999)
        campaign.end = end
      if Meteor.user().profile.paid or isNotAlreadyThreeCampaigns(campaign.firm, campaign.start, campaign.end, campaign._id)
        Campaigns.update(campaign._id,$set: {end:campaign.end, start:campaign.start})
      else
        revertFunc()
    eventClick: (campaign,event) ->
      Session.set('displayCampaign', campaign._id)
  
Template.newCampaign.helpers 
      signatures: -> return Signatures.find({firm: Meteor.user().profile.firm})
      services: -> return Services.find({firm: Meteor.user().profile.firm})

Template.detailsCampaign.helpers 
      campaign: -> return Campaigns.findOne(Session.get('displayCampaign'))
      signature: -> 
        camp = Campaigns.findOne(Session.get('displayCampaign'))
        if camp?
          return Signatures.findOne(camp.signature)
        else return null
      canDelete: ->
        camp = Campaigns.findOne(Session.get('displayCampaign'))
        if camp? and (camp.title is "Default Extern" or camp.title is "Default Intern")
          return false
        else return true
        
Template.detailsCampaign.events
  "click #cancel" : (e,t) ->
    if Session.get('displayCampaign')? and Session.get('displayCampaign') isnt ""
      Campaigns.remove(Session.get('displayCampaign'))
      
Template.newCampaign.events
  "submit" : (e,t) ->
    e.preventDefault();
    name = t.find('#new-campaign-name').value
    signature = t.find('#new-campaign-signature').value  
    service = t.find('#new-campaign-service').value
    notify = t.find('#new-campaign-notify').value
    if service? && service.length? && service.length is 0
      service = null  
    firm = Meteor.user().profile.firm
    if isNotEmpty(name) and isNotAlreadyASameCampaign(name, firm)
      today = new Date()
      today.setHours(0,0,0,0)
      tomorrow = new Date()
      tomorrow.setHours(23,59,59,999)
      campaign = 
        title: name
        signature: signature
        firm: firm
        start: today
        end: tomorrow
        service: service  
        editable: true
        notify: notify == "true"
      Campaigns.insert campaign
      $('#calendar').fullCalendar('renderEvent', campaign, true);      
      $(".md-modal").removeClass("md-show")

isNotAlreadyASameCampaign = (campaign, firm) ->
  if Campaigns.find({$and:[{title:campaign}, {firm: firm}]}).count() is 0
    return true
  else
    Session.set('displayMessage', i18n._.translate("campaigns.alreadySameCampaign"))
    return false; 

isNotAlreadyThreeCampaigns = (firm, date, date2, campaign) ->
  if date2?
    if Campaigns.find({$and: [{_id:{$ne:campaign}},{firm:firm}, {$or: [{$and:[{start: {$lte:date}}, {end: {$gte:date}}]}, {$and:[{start: {$lte:date2}}, {end: {$gte:date2}}]}]}]}).count() < 3
      return true
    else
      Session.set('displayMessage', i18n._.translate("campaigns.upgrade"))
      return false;
  else
    if Campaigns.find({$and: [{firm:firm}, {start: {$lte:date}}, {end: {$gte:date}} ]}).count() < 3
      return true
    else
      Session.set('displayMessage', i18n._.translate("campaigns.upgrade"))
      return false;
      
isNotEmpty = (name) ->
  if name and name isnt ""
    return true
  else
    Session.set('displayMessage', i18n._.translate("campaigns.empty"))
    return false