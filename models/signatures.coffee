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
  update: (userId, doc) ->
    if userId? and doc.name? and doc.firm? and doc.value? and doc.name isnt ""
      firmId = Meteor.users.findOne(userId).profile.firm
      return doc.firm == firmId and isNotAlreadyASameSignature(doc.name, firmId, doc._id)
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
