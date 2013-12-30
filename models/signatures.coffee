###
    The Signatures collection
###

# Declare the collection
@Signatures = new Meteor.Collection("signatures")

@Signatures.allow
    # Client can add records
  insert: (userId, doc) ->
    return true
  update: (userId, doc) ->
    return true
  remove: (userId, doc) ->
    return true
