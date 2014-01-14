###
    The Services collection
###

# Declare the collection
@Services = new Meteor.Collection("services")

@Services.allow
    # Client can add records
  insert: (userId, doc) ->
    if userId? and doc.name? and doc.firm? and doc.name isnt ""
      firmId = Meteor.users.findOne(userId).profile.firm
      return doc.firm == firmId and isNotAlreadyASameService(doc.name, firmId)
    else return false
  update: (userId, doc, fields, modifiers) ->
    if userId? and doc.name? and doc.firm? and (fields.indexOf('name') is -1 or (modifiers['$set'].name? and modifiers['$set'].name isnt ""))
      firmId = Meteor.users.findOne(userId).profile.firm
      if fields.indexOf('name') isnt -1
        return doc.firm == firmId and isNotAlreadyASameService(modifiers['$set'].name, firmId, doc._id)
      return doc.firm == firmId
    else return false
  remove: (userId, doc) ->
    if userId? and doc.name?
      firmId = Meteor.users.findOne(userId).profile.firm
      return doc.firm == firmId
    else return false
    
isNotAlreadyASameService = (service, firm, idService) ->
  if Services.find({name:service, firm: firm}).count() is 0 or Services.findOne({name:service, firm: firm})._id is idService
    return true
  else
    return false; 
