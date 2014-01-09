###
    View logic for the Cars page
###

@ViewCampaigns = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->

        # Use Meteor.render to set our template reactively
          
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
      if Meteor.user().profile.paid or isNotAlreadyThreeCampaigns(campaign.firm, campaign.start, campaign.end, campaign._id)
        Campaigns.update(campaign._id,$set: {end:campaign.end})
      else
        revertFunc()
    eventDrop: (campaign, dayDelta,minuteDelta,allDay,revertFunc) ->
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
    notify = t.find('#new-campaign-notidy').value
    if service? && service.length? && service.length is 0
      service = null  
    firm = Meteor.user().profile.firm
    if isNotAlreadyASameCampaign(name, firm) and name isnt ""
      campaign = 
        title: name
        signature: signature
        firm: firm
        start: new Date()
        end: new Date()
        service: service  
        editable: true
        notify: notify
      Campaigns.insert campaign
      $('#calendar').fullCalendar('renderEvent', campaign, true);      
      $(".md-modal").removeClass("md-show")

isNotAlreadyASameCampaign = (campaign, firm) ->
  if Campaigns.find({$and:[{title:campaign}, {firm: firm}]}).count() is 0
    return true
  else
    Session.set('displayMessage', 'Error &amp; A campaign with that name already exists.')
    return false; 

isNotAlreadyThreeCampaigns = (firm, date, date2, campaign) ->
  if date2?
    if Campaigns.find({$and: [{_id:{$ne:campaign}},{firm:firm}, {$or: [{$and:[{start: {$lte:date}}, {end: {$gte:date}}]}, {$and:[{start: {$lte:date2}}, {end: {$gte:date2}}]}]}]}).count() < 3
      return true
    else
      Session.set('displayMessage', 'Error &amp; You cannot create more than 3 campaigns at the same time. Please upgrade your account to do so.')
      return false;
  else
    if Campaigns.find({$and: [{firm:firm}, {start: {$lte:date}}, {end: {$gte:date}} ]}).count() < 3
      return true
    else
      Session.set('displayMessage', 'Error &amp; You cannot create more than 3 campaigns at the same time. Please upgrade your account to do so.')
      return false;