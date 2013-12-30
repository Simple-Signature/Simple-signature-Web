###
    View logic for the Cars page
###

@ViewSignatures = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
            
    Template.signatures.helpers 
      signatures: -> return Signatures.find({firm: Meteor.user().profile.firm})
      admin: -> 
        if Meteor.user()? && Meteor.user().profile?
          return Meteor.user().profile.admin
        else
          return false
        # Use Meteor.render to set our template reactively

    Template.signatures.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)
      "click i.glyphicon-pencil": (e) ->
        sign = Signatures.findOne({_id:$(e.target).attr("idSign")})
        $("#edit-signature-name").val(sign.name)
        CKEDITOR.instances['edit-signature-content'].setData(sign.value.replace('PATHAPPDATA','/img/'))
        $("#edit-signature-id").val(sign._id)
 
    @template = Meteor.render () ->
      return Template.signatures()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this

Template.signatures.rendered = () ->
  ModalEffects()
  CKEDITOR.replace('new-signature-content',
    customConfig: '/assets/config.js'
  )
  CKEDITOR.replace('edit-signature-content',
    customConfig: '/assets/config.js'
  )

Template.newSignature.events
  "submit" : (e,t) ->
    e.preventDefault();
    name = t.find('#new-signature-name').value
    content = t.find('#new-signature-content').value  
    firm = Meteor.user().profile.firm
    if isNotAlreadyASameSignature(name, firm) and name isnt ""
      sign = Signatures.insert
        name: name
        value: content.replace('/img/','PATHAPPDATA')
        firm: firm
        createdAt: new Date()
        img: null        
      $('#previewSignature').html(content)
      html2canvas($('#previewSignature'),
        onrendered: (canvas) ->        
          data = canvas.toDataURL() 
          Signatures.update({_id:sign},$set:{img:data}) 
          $('#previewSignature').html('')
          App.router.render
      )      
      $(".md-modal").removeClass("md-show")

Template.editSignature.events
  "submit" : (e,t) ->
    e.preventDefault();
    name = t.find('#edit-signature-name').value
    content = t.find('#edit-signature-content').value  
    id = t.find('#edit-signature-id').value  
    firm = Meteor.user().profile.firm
    if isNotAlreadyASameSignature(name, firm, id) and name isnt ""
      Signatures.update(id,{$set: {name: name,value: content.replace('/img/','PATHAPPDATA')}})
      $('#previewSignature').html(content)
      html2canvas($('#previewSignature'),
        onrendered: (canvas) ->        
          data = canvas.toDataURL() 
          Signatures.update({_id:id},$set:{img:data}) 
          $('#previewSignature').html('')
          App.router.render
      )
      $(".md-modal").removeClass("md-show")
      
isNotAlreadyASameSignature = (signature, firm, idSign) ->
  if Signatures.find({name:signature, firm: firm}).count() is 0 or Signatures.findOne({name:signature, firm: firm})._id is idSign
    return true
  else
    Session.set('displayMessage', 'Error &amp; A signature with that name already exists.')
    return false; 