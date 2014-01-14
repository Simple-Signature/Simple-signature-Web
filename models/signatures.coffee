###
    The Signatures collection
###

# Declare the collection
@Signatures = new Meteor.Collection("signatures")

@Signatures.allow
    # Client can add records
  insert: (userId, doc) ->
    if userId? and doc.name? and doc.firm? and doc.value? and doc.name isnt ""
      firmId = Meteor.users.findOne(userId).profile.firm
      return doc.firm == firmId and isNotAlreadyASameSignature(doc.name, firmId)
    else return false
  update: (userId, doc, fields, modifiers) ->
    if userId? and doc.name? and doc.firm? and doc.value? and (fields.indexOf('name') is -1 or (modifiers['$set'].name? and modifiers['$set'].name isnt ""))
      firmId = Meteor.users.findOne(userId).profile.firm
      if fields.indexOf('name') isnt -1
        return doc.firm == firmId and isNotAlreadyASameSignature(modifiers['$set'].name, firmId, doc._id)
      return doc.firm == firmId
    else return false
  remove: (userId, doc) ->
    if userId? and doc.name? and doc.name isnt "interne default" and doc.name isnt "externe default"
      firmId = Meteor.users.findOne(userId).profile.firm
      return doc.firm == firmId
    else return false
    
isNotAlreadyASameSignature = (signature, firm, idSign) ->
  if Signatures.find({name:signature, firm: firm}).count() is 0 or Signatures.findOne({name:signature, firm: firm})._id is idSign
    return true
  else
    return false; 
