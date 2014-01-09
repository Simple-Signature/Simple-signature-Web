###
    View logic for the Users page
###

@ViewUsers = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
            
    Template.users.helpers 
      users: -> return Meteor.users.find({'profile.firm': Meteor.user().profile.firm})
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

    Template.users.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      "click .editUserButton": (e) ->
        id = $(e.target).attr("idUser")
        if !id?
          id = $(e.target).parent().attr("idUser")
        user = Meteor.users.findOne(id)
        $("#edit-user-email").val(user.emails[0].address)
        $("#edit-user-id").val(user._id)
      "click .removeUserButton": (e) ->
        id = $(e.target).attr("idUser")
        if !id?
          id = $(e.target).parent().attr("idUser")
        Meteor.users.remove(id)
      "click .dropdown-user" : (e) ->
        dataFor = $(e.target).attr('data-for')
        currentButton = $(e.target)
        if !dataFor?
          dataFor = $(e.target).parent().attr('data-for')
          currentButton = $(e.target).parent()
        idFor = $(dataFor)      
        idFor.slideToggle(400, () ->
          if idFor.is(':visible')
            currentButton.html('<i class="glyphicon glyphicon-chevron-up text-muted"></i>')
          else
            currentButton.html('<i class="glyphicon glyphicon-chevron-down text-muted"></i>')
        )

      
    @template = Meteor.render () ->
      return Template.users()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this

Template.users.rendered = () ->
  ModalEffects()
  panels = $('.user-infos')
  panelsButton = $('.dropdown-user')
  panels.hide()
  panelsButton.click () ->
  $('[data-toggle="tooltip"]').tooltip()

Template.newUser.events
  "submit" : (e,t) ->
    e.preventDefault()
    email = t.find('#new-user-email').value
    password = t.find('#new-user-password').value 
    if email isnt ""          
      $(".md-modal").removeClass("md-show")

Template.editUser.events
  "submit" : (e,t) ->
    e.preventDefault();
    id = t.find('#edit-user-id').value  
    email = t.find('#edit-user-email').value
    password = t.find('#edit-user-password').value 
    if email isnt ""          
      $(".md-modal").removeClass("md-show")