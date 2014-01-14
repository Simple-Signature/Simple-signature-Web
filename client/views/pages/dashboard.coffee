###
    View logic for the dashboard page
###
colorArray = ["52, 152, 219","46, 204, 113", "231, 76, 60","26, 188, 156","241, 196, 15","230, 126, 34","149, 165, 166","52, 73, 94"]
@ViewDashboard = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    Session.set('sidebar', 'dashboard')
      
    i18n.i18nMessages.dashboard =
      signatures: 
        en: "View Signatures"
        fr: "Voir les Signatures"
      campaigns: 
        en: "Current Campaigns"
        fr: "Campagnes en cours"
      voircampaigns: 
        en: "View Campaigns"
        fr: "Voir les Campagnes"
      users: 
        en: "Manage users"
        fr: "Gérer les utilisateurs"
      mails: 
        en: "Number of Mails sent"
        fr: "Nombre de Mails envoyés"
        
    Template.dashboard.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)

    @template = Meteor.render () ->
      return Template.dashboard()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this

Template.dashboard.helpers
  admin: () -> return Meteor.user()? and Meteor.user().profile? and Meteor.user().profile.admin
  signatures: () -> return Signatures.find({firm: Meteor.user().profile.firm}).count()
  campaigns: () -> return Campaigns.find({firm: Meteor.user().profile.firm}).count()
  users: () -> return Meteor.users.find({'profile.firm': Meteor.user().profile.firm}).count()
  beginStatDate: () -> 
    date=new Date()
    date.setDate(new Date().getDate()-30)
    return date
  endStatDate: () -> return new Date()
  
Template.dashboard.rendered = () ->
  $("#statChart").attr("width",$("#panelStat").width())
  signs = []
  stats = Stats.find({$and:[{timestamp:{$lte:new Date()}},{timestamp:{$gte:pushDate(31)}}]})
  stats.forEach (stat) -> if not (stat.signature in signs) then signs.push stat.signature
  if signs.length is 0
    $("#panelStat").html("No mail sent for the moment")
  else
    ctx = document.getElementById("statChart").getContext("2d")
    data = {}
    data.labels = []
    data.datasets = []
    data.labels.push(pushDate(i).getDate()) for i in [30..0]
    signsData = []
    signsData.push([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]) for i in [0...signs.length]
    stats.forEach (stat) ->
      signsData[signs.indexOf stat.signature][30-Math.floor(( new Date() - stat.timestamp )/86400000)]+=1
    for n, i in signsData
      do (n, i) ->
        data.datasets.push 
          fillColor:"rgba("+colorArray[i % 8]+",0.5)"
          strokeColor:"rgba("+colorArray[i % 8]+",1)"
          pointColor:"rgba("+colorArray[i % 8]+",1)"
          pointStrokeColor:"fff"
          data:n
    console.log(data)
    chart = new Chart(ctx).Line(data)
  
pushDate = (i) ->
  date=new Date()
  date.setDate(new Date().getDate()-i)
  return date