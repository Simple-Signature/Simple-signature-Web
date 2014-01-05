###
    The Stats collection
###

# Declare the collection
@Stats = new Meteor.Collection("stats")

@Stats.allow
    # Client can do nothing
    insert: (userId, doc) ->
        return false
    update: (userId, doc) ->
        return false
    remove: (userId, doc) ->
        return false