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
        # Use Meteor.render to set our template reactively

    Template.users.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      "click i.glyphicon-pencil": (e) ->
        user = Meteor.users.findOne($(e.target).attr("idUser"))
        $("#edit-user-email").val(user.emails[0].address)
        $("#edit-user-id").val(sign._id)
      "click i.glyphicon-remove": (e) ->
        Meteor.users.remove($(e.target).attr("idUser"))
      
    @template = Meteor.render () ->
      return Template.users()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this

Template.users.rendered = () ->
  ModalEffects()

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