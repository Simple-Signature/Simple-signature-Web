# Publish the collection to the client
Meteor.publish "services", ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return Services.find({ firm: user.profile.firm })
    
Meteor.publish "firms", () ->
  return Firms.find()

Meteor.publish "campaigns", () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return Campaigns.find({ firm: user.profile.firm })
  
Meteor.publish "signatures", () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return Signatures.find({ firm: user.profile.firm })

Meteor.publish 'images', () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return FirmsImages.find({ 'metadata.firm': user.profile.firm })

Meteor.publish 'stats', () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return Stats.find({ firm: user.profile.firm })

Meteor.publish 'allUsersData', () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user? and user.profile? and user.profile.firm?
      return Meteor.users.find({'profile.firm': user.profile.firm},{fields: {'createdAt': 1, 'emails': 1, 'profile': 1}});