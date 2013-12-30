###
    View logic for the home page
###

@Home = Backbone.View.extend

  # The Meteor template used by this view
  template: null

  initialize: () ->
    Template.landing.events
      # Prevent the page reloading for links
      "click a": (e) ->
        App.router.aReplace(e)

    @template = Meteor.render () ->
      return Template.landing()

    # Render the view on its $el parameter and return the view itself
  render: () ->
    @$el.html(@template)
    return this

Template.landing.rendered = () ->
  $(document).ready () ->
    scrollorama = $.scrollorama
      blocks:'.scrollblock'
      enablePin:false
    scrollorama.animate('#mail1',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail2',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail3',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail4',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail5',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#arrow',
      duration:20
      property:'opacity'
      end: 1
    )
    scrollorama.animate('#mail1',
      duration:700
      property:'right'
      start: -1200
      end: 500
    )
    scrollorama.animate('#mail1',
      duration:700
      property:'top'
      start: -200
      end: 0
    )
    scrollorama.animate('#mail2',
      duration:700
      property:'right'
      start: 500
      end: 200
    )
    scrollorama.animate('#mail2',
      duration:700
      property:'top'
      start: -500
      end: 300
    )
    scrollorama.animate('#mail3',
      delay:300
      duration:400
      property:'right'
      start: 200
      end: 500
    )
    scrollorama.animate('#mail3',
      delay:300
      duration:400
      property:'top'
      start: 200
      end: 320
    )
    scrollorama.animate('#mail4',
      delay:300
      duration:400
      property:'right'
      start: -120
      end: -290
    )
    scrollorama.animate('#mail4',
      delay:300
      duration:400
      property:'top'
      start: -40
      end: -130
    )
    scrollorama.animate('#mail5',
      delay:300
      duration:400
      property:'right'
      start: -300
      end: -100
    )
    scrollorama.animate('#mail5',
      delay:300
      duration:400
      property:'top'
      start: 150
      end: 200
    )
    scrollorama.animate('#arrow',
      duration:500
      property:'top'
      start: 300
      end: 175
    )
    scrollorama.animate('#arrow',
      duration:600
      property:'left'
      start: -600
      end: 145
    )