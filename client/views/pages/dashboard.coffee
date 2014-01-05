###
    View logic for the dashboard page
###

@ViewDashboard = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
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
  
Template.dashboard.rendered = () ->
  $("#statChart").attr("width",$("#panelStat").width())
  ctx = document.getElementById("statChart").getContext("2d")
  data = {}
  data.labels = []
  pushDate(data.labels, i) for i in [30..0]
  data.datasets = [{fillColor : "rgba(220,220,220,0.5)",strokeColor : "rgba(220,220,220,1)",pointColor : "rgba(220,220,220,1)",pointStrokeColor : "#fff",data : [65,59,90,81,56,55,40,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]},{fillColor : "rgba(151,187,205,0.5)",strokeColor : "rgba(151,187,205,1)",pointColor : "rgba(151,187,205,1)",pointStrokeColor : "#fff",data : [28,48,40,19,96,27,100,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]}]
  chart = new Chart(ctx).Line(data)
  
pushDate = (t, i) ->
  date=new Date()
  date.setDate(new Date().getDate()-i)
  t.push(date.getDate())