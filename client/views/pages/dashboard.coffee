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

Template.dashboard.admin = () ->
  if Meteor.user()? && Meteor.user().profile?
    return Meteor.user().profile.admin
  else
    return false