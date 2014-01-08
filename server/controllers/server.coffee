###
    The main server file, general server side code should go here
###
  
# Set permissions on the users collection
Meteor.users.allow
    # A user can update their own record
  update: (userId, doc) ->
    if userId == @userId
      return true
    else 
      currentUser = Meteor.users.findOne(this.userId)
      firmIdAdmin = Meteor.users.findOne(userId).profile.firm
      return currentUser.firm is firmIdAdmin and currentUser.admin

# Publish the collection to the client
Meteor.publish "services", ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user && user.profile && user.profile.firm
      return Services.find({ firm: user.profile.firm })
    
Meteor.publish "firms", () ->
  return Firms.find()

Meteor.publish "campaigns", () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user && user.profile && user.profile.firm
      return Campaigns.find({ firm: user.profile.firm })
  
Meteor.publish "signatures", () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user && user.profile && user.profile.firm
      return Signatures.find({ firm: user.profile.firm })

Meteor.publish 'images', () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user && user.profile && user.profile.firm
      return FirmsImages.find({ 'metadata.firm': user.profile.firm })

Meteor.publish 'stats', () ->
  if this.userId?
    user = Meteor.users.findOne(this.userId)
    if user && user.profile && user.profile.firm
      return Stats.find({ firm: user.profile.firm })
  
Meteor.Router.add
  '/API/signs/:firm/:service': (firm, service) ->
    this.response.setHeader("Access-Control-Allow-Origin","*")
    this.response.setHeader("Access-Control-Allow-Headers","X-Requested-With")
    firms = Firms.findOne({name:firm})
    service = Services.findOne({name:service})
    if firms?
      campaigns = Campaigns.find({$and: [{firm:firms._id}, {start: {$lte:new Date()}}, {end: {$gte:new Date()}} ]},{fields:{signature:1}}).fetch()
      if campaigns?
        campaignsId=[]
        campaigns.forEach (campaign) -> 
          if campaign.service?
            campaign.service.every (serv) ->
              if serv is service
                campaignsId.push(campaign.signature)
                return false
              else
                return true
          else
            campaignsId.push(campaign.signature)
        signatures = Signatures.find({_id:{$in: campaignsId}}).fetch()
        return [200,JSON.stringify(signatures)]
      else
        return [400,"Aucune campagne en cours"]
    else
      return [400,"Il semble que vous n'avez pas créé de compte Simple Signature"]

Meteor.Router.add
  '/API/signs/:firm': (firm) ->
    this.response.setHeader("Access-Control-Allow-Origin","*")
    this.response.setHeader("Access-Control-Allow-Headers","X-Requested-With")
    firms = Firms.findOne({name:firm})
    if firms?
      campaigns = Campaigns.find({$and: [{firm:firms._id}, {start: {$lte:new Date()}}, {end: {$gte:new Date()}} ]},{fields:{signature:1}}).fetch()
      if campaigns?
        campaignsId=[]
        campaigns.forEach (campaign) -> 
          if !campaign.service?
            campaignsId.push(campaign.signature)
        signatures = Signatures.find({_id:{$in: campaignsId}}).fetch()
        return [200,JSON.stringify(signatures)]
      else
        return [400,"Aucune campagne en cours"]
    else
      return [400,"Il semble que vous n'avez pas créé de compte Simple Signature"]

Meteor.Router.add
  '/API/stats/:firm/:signature/:externe/:interne': (firm, signature, externe, interne) ->
    this.response.setHeader("Access-Control-Allow-Origin","*")
    this.response.setHeader("Access-Control-Allow-Headers","X-Requested-With")
    Stats.insert
      firm:firm
      signature:signature
      externe:externe
      interne:interne
      timestamp:new Date()
    return [200,"OK"]