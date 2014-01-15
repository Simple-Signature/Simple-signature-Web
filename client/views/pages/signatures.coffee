###
    View logic for the Cars page
###
@imagesList = []
@ViewSignatures = Backbone.View.extend

    # The Meteor template used by this view
  template: null

    # Called on creation
  initialize: () ->
    Session.set('sidebar', 'signatures')
      
    i18n.i18nMessages.signatures =
      create: 
        en: "Create a new signature"
        fr: "Créer une nouvelle signature"
      name: 
        en: "Name"
        fr: "Nom"
      date: 
        en: "Creation date"
        fr: "Date de création"
      edit: 
        en: "Edit this signature"
        fr: "Modifier cette signature"
      remove: 
        en: "Remove this signature"
        fr: "Supprimer cette signature"
      newtitle:
        en: "New Signature"
        fr: "Nouvelle Signature"
      edittitle:
        en: "Edition of the signature"
        fr: "Modification de la signature"
      content:
        en: "Content"
        fr: "Contenu"
      createbutton:
        en: "Create"
        fr: "Créer"
      editbutton:
        en: "Edit"
        fr: "Modifier"
      alreadySameSign:
        en: "Error &amp; A signature with that name already exists." 
        fr: "Erreur &amp; Une signature avec ce nom existe déjà."
      empty:
        en: "Error &amp; The name must not be empty." 
        fr: "Erreur &amp; Le nom ne doit pas être vide."    
                
    Template.signatures.helpers 
      signatures: -> 
        @imagesList = []
        imgs = FirmsImages.find()
        imgs.forEach((image) -> @imagesList.push([image.metadata.title, image.url()]))
        return Signatures.find({firm: Meteor.user().profile.firm})
      admin: -> 
        if Meteor.user()? && Meteor.user().profile?
          return Meteor.user().profile.admin
        else
          return false
        # Use Meteor.render to set our template reactively

    Template.signatures.events
      # Prevent the page reloading for links
      "click #cke_edit-signature-content a" : () ->
        return false
      "click #cke_new-signature-content a" : () ->
        return false
      "click a": (e) ->
        App.router.aReplace(e)
      "click .editSignButton": (e) ->
        id = $(e.target).attr("idSign")
        if !id?
          id = $(e.target).parent().attr("idSign")
        sign = Signatures.findOne(id)
        $("#edit-signature-name").val(sign.name)
        CKEDITOR.instances['edit-signature-content'].setData(sign.value.replace(/PATHAPPDATA/g,'/cfs/files/images/'))
        $("#edit-signature-id").val(sign._id)
      "click .removeSignButton": (e) ->
        id = $(e.target).attr("idSign")
        if !id?
          id = $(e.target).parent().attr("idSign")
        Signatures.remove(id)
        
      
    @template = Meteor.render () ->
      return Template.signatures()
    
    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el = (@template)
    return this

Template.signatures.rendered = () ->
  ModalEffects()
  $('[data-toggle="tooltip"]').tooltip()
  CKEDITOR.replace('new-signature-content')
  CKEDITOR.replace('edit-signature-content')

Template.newSignature.events
  "submit" : (e,t) ->
    e.preventDefault()
    name = t.find('#new-signature-name').value
    content = t.find('#new-signature-content').value  
    firm = Meteor.user().profile.firm
    if isNotEmpty(name) and isNotAlreadyASameSignature(name, firm)
      sign = Signatures.insert
        name: name
        value: content.replace(/\/cfs\/files\/images\//g,'PATHAPPDATA')
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
    if isNotEmpty(name) and isNotAlreadyASameSignature(name, firm, id)
      Signatures.update(id,{$set: {name: name,value: content.replace(/\/cfs\/files\/images\//g,'PATHAPPDATA')}})
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
    Session.set('displayMessage', i18n._.translate("signatures.alreadySameSign"))
    return false
    
isNotEmpty = (name) ->
  if name and name isnt ""
    return true
  else
    Session.set('displayMessage', i18n._.translate("signatures.empty"))
    return false