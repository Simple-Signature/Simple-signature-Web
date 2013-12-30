###
    The Services collection
###

# Declare the collection
@Services = new Meteor.Collection("services")

@Services.allow
    # Client can add records
    insert: (userId, doc) ->
        return true
    update: (userId, doc) ->
        return true
    remove: (userId, doc) ->
        return true
