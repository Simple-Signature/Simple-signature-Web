###
    View logic for the Users page
###

@ViewServices = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
    Session.set('sidebar', 'services')
      
    i18n.i18nMessages.services =
      create: 
        en: "Create a new service"
        fr: "Créer une nouveau service"
      info: 
        en: "Service information"
        fr: "Information sur le service"
      registered: 
        en: "Created since :"
        fr: "Créé depuis :"
      edit: 
        en: "Edit this service"
        fr: "Modifier ce service"
      remove: 
        en: "Remove this service"
        fr: "Supprimer ce service"
      newtitle:
        en: "New Service"
        fr: "Nouveau Service"
      edittitle:
        en: "Edition of the service"
        fr: "Modification du service"
      name:
        en: "Name"
        fr: "Nom"
      createbutton:
        en: "Create"
        fr: "Créer"
      editbutton:
        en: "Edit"
        fr: "Modifier"
      alreadySameService:
        en: "Error &amp; A service with that name already exists." 
        fr: "Erreur &amp; Un service avec ce nom existe déjà."
      empty:
        en: "Error &amp; The name must not be empty." 
        fr: "Erreur &amp; Le nom ne doit pas être vide." 
                
    Template.services.helpers 
      services: -> return Services.find({firm: Meteor.user().profile.firm})
      admin: -> 
        if Meteor.user()? && Meteor.user().profile?
          return Meteor.user().profile.admin
        else
          return false
      paid: ->
        if Meteor.user()? && Meteor.user().profile?
          return Meteor.user().profile.paid
        else
          return false
        # Use Meteor.render to set our template reactively

    Template.services.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      "click .editServiceButton": (e) ->
        id = $(e.target).attr("idService")
        if !id?
          id = $(e.target).parent().attr("idService")
        service = Services.findOne(id)
        $("#edit-service-name").val(service.name)
        $("#edit-service-id").val(id)
      "click .removeServiceButton": (e) ->
        id = $(e.target).attr("idService")
        if !id?
          id = $(e.target).parent().attr("idService")
        Services.remove(id)
      "click .dropdown-user" : (e) ->
        dataFor = $(e.target).attr('data-for')
        currentButton = $(e.target)
        if !dataFor?
          dataFor = $(e.target).parent().attr('data-for')
          currentButton = $(e.target).parent()
        idFor = $(dataFor)      
        idFor.slideToggle(400, () ->
          if idFor.is(':visible')
            currentButton.html('<i class="icon-arrow-up text-muted"></i>')
          else
            currentButton.html('<i class="icon-arrow-down text-muted"></i>')
        )

      
    @template = Meteor.render () ->
      return Template.services()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this

Template.services.rendered = () ->
  ModalEffects()
  panels = $('.user-infos')
  panelsButton = $('.dropdown-user')
  panels.hide()
  panelsButton.click () ->
  $('[data-toggle="tooltip"]').tooltip()

Template.newService.events
  "submit" : (e,t) ->
    e.preventDefault()
    name = t.find('#new-service-name').value
    firm = Meteor.user().profile.firm
    if isNotEmpty(name) and isNotAlreadyASameService(name, firm)
      Signatures.insert
        name: name
        firm: firm
        createdAt: new Date()    
      $(".md-modal").removeClass("md-show")

Template.editUser.events
  "submit" : (e,t) ->
    e.preventDefault();
    id = t.find('#edit-service-id').value  
    name = t.find('#edit-service-name').value
    if isNotEmpty(name) and isNotAlreadyASameService(name, firm, id)
      Signatures.update(id, $set:{name: name})      
      $(".md-modal").removeClass("md-show")

isNotAlreadyASameService = (service, firm, idService) ->
  if Services.find({name:service, firm: firm}).count() is 0 or Service.findOne({name:service, firm: firm})._id is idService
    return true
  else
    Session.set('displayMessage', i18n._.translate("services.alreadySameService"))
    return false
    
isNotEmpty = (name) ->
  if name and name isnt ""
    return true
  else
    Session.set('displayMessage', i18n._.translate("services.empty"))
    return false