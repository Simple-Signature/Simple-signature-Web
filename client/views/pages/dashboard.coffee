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
    