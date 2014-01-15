Meteor.Router.add
  '/API/signs/:firm/:service': (firm, service) ->
    this.response.setHeader("Access-Control-Allow-Origin","*")
    this.response.setHeader("Access-Control-Allow-Headers","X-Requested-With")
    firms = Firms.findOne({name:firm})
    service = Services.findOne({name:service})
    if firms?
      today = new Date()
      today.setHours(12,0,0,0)
      campaigns = Campaigns.find({$and: [{firm:firms._id}, {start: {$lte:today}}, {end: {$gte:today}} ]},{fields:{signature:1}}).fetch()
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
      today = new Date()
      today.setHours(12,0,0,0)
      campaigns = Campaigns.find({$and: [{firm:firms._id}, {start: {$lte:today}}, {end: {$gte:today}} ]},{fields:{signature:1}}).fetch()
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
    
Meteor.Router.add
  '/subscription/ok/': () ->
    ppHostname = "www.paypal.com" # Change to www.paypal.com to test against sandbox

    # read the post from PayPal system and add 'cmd'
    req.cmd = "_notify-synch"
    req.tx = this.request.query.tx
    req.at = "OIBNjHe1jpiFkv7i08fWyPm3ENG-eWC8uj5CYUBM0lu7OEWFcdh9FZF5nw0"
    try
      res = HTTP.POST("https://"+ppHostname+"/cgi-bin/webscr", {params:req, headers:["Host: "+ppHostname]})
      if  (!res)
        this.response.writeHead '302', {'Location': '/subscription/return/notOk'}
      else
        # parse the data
        lines = res.split("\n")
        keyarray = []
        if lines[0].indexOf("SUCCESS") == 0 

          keyarray[line.split("=")[0]] = line.split("=")[1] for line in lines[1..]
        
          # check the payment_status is Completed
          # check that txn_id has not been previously processed
          # check that receiver_email is your Primary PayPal email
          # check that payment_amount/payment_currency are correct
          # process payment
          status = keyarray.payment_status
          idFirm = keyarray.custom
          if status is "Completed" or status is "Processed"
            Meteor.users.update({'profile.firm':idFirm},$set:{'profile.paid':true})
            this.response.writeHead '302', {'Location': '/subscription/return/ok'}
          else if status is "Pending"
            this.response.writeHead '302', {'Location': '/subscription/return/pending'}
          else 
            this.response.writeHead '302', {'Location': '/subscription/return/notOk'}
        else if lines[0].indexOf("FAIL") == 0
          this.response.writeHead '302', {'Location': '/subscription/return/notOk'}
          console.log(res)
          # log for manual investigation
    catch e
      console.log(e)
      this.response.writeHead '302', {'Location': '/subscription/return/notOk'}