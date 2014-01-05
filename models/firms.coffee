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