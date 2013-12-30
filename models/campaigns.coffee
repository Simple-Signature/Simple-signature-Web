###
    The Campaigns collection
###

# Declare the collection
@Campaigns = new Meteor.Collection("campaigns")

@Campaigns.allow
    # Client can add records
    insert: (userId, doc) ->
        return true
    update: (userId, doc) ->
        return true
    remove: (userId, doc) ->
        return true