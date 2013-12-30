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
  $('#calendar').fullCalendar
    events: Campaigns.find({firm: Meteor.user().profile.firm}).fetch()
    eventResize: (campaign, dayDelta) ->
      Campaigns.update({_id: campaign._id},$set: {end:new Date(new Date(campaign.end).getDate()+dayDelta)})
    eventDrop: (campaign, dayDelta) ->
      Campaigns.update({_id: campaign._id},$set: {end:new Date(new Date(campaign.end).getDate()+dayDelta), start:new Date(new Date(campaign.start).getDate()+dayDelta)})
  
Template.newCampaign.helpers 
      signatures: -> return Signatures.find({firm: Meteor.user().profile.firm})
      services: -> return Services.find({firm: Meteor.user().profile.firm})

Template.newCampaign.events
  "submit" : (e,t) ->
    e.preventDefault();
    name = t.find('#new-campaign-name').value
    signature = t.find('#new-campaign-signature').value  
    service = t.find('#new-campaign-service').value
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
      Campaigns.insert campaign
      $('#calendar').fullCalendar('renderEvent', campaign, true);      
      $(".md-modal").removeClass("md-show")

isNotAlreadyASameCampaign = (campaign, firm) ->
  if Campaigns.find({title:campaign, firm: firm}).count() is 0
    return true
  else
    Session.set('displayMessage', 'Error &amp; A campaign with that name already exists.')
    return false; 