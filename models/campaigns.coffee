###
    The Campaigns collection
###

# Declare the collection
@Campaigns = new Meteor.Collection("campaigns")

@Campaigns.allow
    # Client can add records
  insert: (userId, doc) ->
    if userId? and doc.title? and doc.firm? and doc.title!="" and doc.start? and doc.end? and doc.signature? and doc.title isnt "" 
      firmId = Meteor.users.findOne(userId).profile.firm
      return  doc.firm == firmId and isNotAlreadyASameCampaign(doc.title, firmId)
    else return false
  update: (userId, doc, fields, modifiers) ->
    if userId? and doc.title? and doc.firm? and (fields.indexOf('start') is -1 or modifiers['$set'].start?) and (fields.indexOf('end') is -1 or modifiers['$set'].end?) and doc.signature? and doc.title isnt "Default Intern" and doc.title isnt "Default Extern"
      user = Meteor.users.findOne(userId)
      if fields.indexOf('start') isnt -1
        start = modifiers['$set'].start
      else
        start = doc.start
      if fields.indexOf('end') isnt -1
        end = modifiers['$set'].end
      else
        end = doc.end
      return (user.profile.paid or isNotAlreadyThreeCampaigns(doc.firm, start, end, doc._id)) and doc.firm == user.profile.firm
    else return false
  remove: (userId, doc) ->
    if userId? and doc.title? and doc.firm? and doc.title isnt "Default Intern" and doc.title isnt "Default Extern"
      user = Meteor.users.findOne(userId)
      return doc.firm == user.profile.firm
    else return false

isNotAlreadyThreeCampaigns = (firm, date, date2, campaign) ->
  if date2?
    if Campaigns.find({$and: [{_id:{$ne:campaign}},{firm:firm}, {$or: [{$and:[{start: {$lte:date}}, {end: {$gte:date}}]}, {$and:[{start: {$lte:date2}}, {end: {$gte:date2}}]}]}]}).count() < 3
      return true
    else
      return false;
  else
    if Campaigns.find({$and: [{firm:firm}, {start: {$lte:date}}, {end: {$gte:date}} ]}).count() < 3
      return true
    else
      return false;
      
isNotAlreadyASameCampaign = (campaign, firm) ->
  if Campaigns.find({$and:[{title:campaign}, {firm: firm}]}).count() is 0
    return true
  else
    return false; 