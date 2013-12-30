###
    The Firms collection
###

# Declare the collection
@Firms = new Meteor.Collection("firms")

@FirmsImages = new CollectionFS('firms', {autopublish:false})

@Firms.allow
    # Client can add records
  insert: (userId, doc) ->
    return true
  update: (userId, doc) ->
    return false
  remove: (userId, doc) ->
    return false

@FirmsImages.allow
  insert: (userId, file) ->
    if userId?
      firmId = Meteor.users.findOne({_id:userId}).firm
      return file.firm == firmId
    else return false
  update: (userId, files, fields, modifier) ->
    if userId?
      firmId = Meteor.users.findOne({_id:userId}).firm
      return _.all(files, (file) ->
        return firmId == file.firm
      )
    else return false
  remove: (userId, files) ->
    if userId?
      firmId = Meteor.users.findOne({_id:userId}).firm
      return _.all(files, (file) ->
        return firmId == file.firm
      )
    else return false
    
@FirmsImages.filter
  allow: 
    contentTypes: ['image/*']