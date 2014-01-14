###
    The Firms collection
###

# Declare the collection
@Firms = new Meteor.Collection("firms")
if Meteor.isServer
  @FirmsImages = new FS.Collection('images', {store: new FS.FileSystemStore("images", Npm.require('path').resolve('..')+"/client/app/img"), autopublish:false, filter: {allow:contentTypes: ['image/*']}})
else @FirmsImages = new FS.Collection('images')

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
    if userId? and file.metadata.title? and file.metadata.firm?
      firmId = Meteor.users.findOne(userId).profile.firm
      return file.metadata.firm == firmId and isNotAlreadyASameImage(file.metadata.title, firmId)
    else return false
  update: (userId, files, fields, modifiers) ->
    return false
  remove: (userId, files) ->
    if userId?
      firmId = Meteor.users.findOne(userId).profile.firm
      if files.length?
        return _.all(files, (file) ->
          return firmId == file.metadata.firm
        )
      else return firmId == files.metadata.firm
    else return false

isNotAlreadyASameImage = (title, firm) ->
  if FirmsImages.find({'metadata.title':title, 'metadata.firm': firm}).count() is 0
    return true
  else
    return false; 