###
    View logic for the images page
###
@ViewImages = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
            
    Template.images.helpers 
      images: -> return FirmsImages.find()
      admin: -> 
        if Meteor.user()? && Meteor.user().profile?
          return Meteor.user().profile.admin
        else
          return false
        # Use Meteor.render to set our template reactively

    Template.images.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      
    @template = Meteor.render () ->
      return Template.images()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this
    
Template.images.rendered = () ->
  ModalEffects()
      
Template.uploadImage.events
  'invalid': (type, fileRecord) ->
    if type is CFSErrorType.disallowedContentType or type is CFSErrorType.disallowedExtension
      Session.set('displayMessage', 'Error &amp; '+ fileRecord.filename + ' is not the type of image.')
    else if type is CFSErrorType.maxFileSizeExceeded
      Session.set('displayMessage', 'Error &amp; '+ fileRecord.filename + ' is too big.')
    else
      Session.set('displayMessage', 'Error &amp; '+ fileRecord.filename + ' is invalide.')
  "submit" : (e,t) ->
    e.preventDefault();
    file = t.find('#new-image-image').files[0]
    title = t.find('#new-image-title').value   
    firm = Meteor.user().profile.firm
    if isNotAlreadyASameImage(title, firm) and title isnt ""
      store = new FS.File(file)
      store.metadata = 
        title:title
        firm:firm
      console.log(store)
      FirmsImages.insert(store)       
      $(".md-modal").removeClass("md-show")
  
isNotAlreadyASameImage = (title, firm) ->
  if FirmsImages.find({'metadata.title':title, 'metadata.firm': firm}).count() is 0
    return true
  else
    Session.set('displayMessage', 'Error &amp; An image with that name already exists.')
    return false; 