###
    View logic for the home page
###

@ViewNotFound = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    @template = Meteor.render () ->
      return Template.notFound()

    Template.notFound.events
    # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace e

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this