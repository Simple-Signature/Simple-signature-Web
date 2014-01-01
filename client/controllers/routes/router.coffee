###
    Main router for the project
###

@Router = Backbone.Router.extend 
  routes :
    "signatures": "signatures"	
    "campaigns": "campaigns"		
    "account": "account"
    "services/:id": "service"
    "services": "services"
    "dashboard": "dashboard"
    "signup": "signup"
    "": "home"
    "*path": "noteFound" # For any other path, go 404
    

    # The current view
  view: null

    # Selector for the div that will contain each page
  page_parent_sel: "#content"

    # Selector for the container of the login component
  page_header_sel: "#header"

    # Google Analytics instance variable
  #_gaq: null

    # Constructor
  initialize: () ->
        # Create a component view that renders in the page template, on every page
    @renderHeader()

        # Setup Google Analytics (change UA-XXXXX-X to your own Google Analytics number!)
    ###`this._gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    g.src='//www.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g,s)}(document,'script'));`

        # Bind a Google Analytics track event to every page change
    @bind 'all', @_trackPageview###

    # Methods for each route
  home: () ->
    @.go Home

  signatures: () ->
    @.go ViewSignatures, true

  campaigns: () ->
    @.go ViewCampaigns, true
        
  services: () ->
    @.go ViewServices, true

  service: () ->
    @.go ViewService, true, id
        
  account: () ->
    @.go ViewAccount, true
        
  dashboard: () ->
    @.go ViewDashboard, true

  notFound: () ->
    @.go ViewNotFound

  signup: () ->
    @.go ViewSignup

    # Actually changes the page by creating the view and inserting it
  go: (viewClass, internal, params) ->
    if !viewClass?
      viewClass = ViewNotFound 
        # Pages that are "internal" can only be viewed by a logged in user
    
        # If all is well, go to the requested page!
    if !internal or (Meteor.userId()? and Meteor.user()? and Meteor.user().profile?)
      @view = new viewClass(params)
      @render()
    else
      @.go ViewNotFound

    # Render the current view
  render: () ->
    $(".modal-backdrop").remove()
    $(".md-modal").removeClass("md-show")
    $(@page_parent_sel).html(@view.render().$el)
    
  renderHeader: () ->
    @viewHeader = new ViewHeader()
    $(@page_header_sel).html(@viewHeader.render().$el)
    
    # Method to replace an anchor tag event with a Backbone route event
  aReplace: (e) ->
        # Don't let the page reload like normal
    if @getHref(e.target).slice(-1) isnt "#"
      e.preventDefault()
        # Parse out the part of the url the router needs
      a = document.createElement("a")
      a.href = @getHref(e.target)
      route = a.pathname + a.search
        # Route using the Backbone router without a page refresh
      @navigate(route, {trigger: true})

        # Scroll to the top of the new page
      window.scrollTo(0,0)
      return false

    # Gets the href attribute from an element, or if null, from the element's first parent that has the attribute
  getHref: (elt) ->
    if elt.href?
      return elt.href
    else
      return @getHref(elt.parentElement)
      
  APIsend: (firm, service) ->
    Deps.autorun () ->
      Meteor.subscribe("firms")
      firms = Firms.findOne({name:firm})
      if firms?
        campaigns = Campaigns.find({$and: [{firm:firms._id}, {$or:[{service:service},{service:null}]}, {start: {$lte:new Date()}}, {end: {$gte:new Date()}} ]},{fields:{signature:1}}).fetch()
        if campaigns?
          campaignsId=[]
          campaigns.forEach((campaign) -> campaignsId.push(campaign.signature))
          signatures = Signatures.find({_id:{$in: campaignsId}}).fetch()
          console.log(signatures)
          $('html').html(JSON.stringify(signatures))
        else
          $('html').html("Aucune campagne en cours")
      else
        $('html').html("Il semble que vous n'avez pas créé de compte Simple Signature")
    
    # Let Google Analytics know that the page has changed
  _trackPageview: ->
    url = Backbone.history.getFragment()
    @_gaq.push(['_trackPageview', "/#{url}"])