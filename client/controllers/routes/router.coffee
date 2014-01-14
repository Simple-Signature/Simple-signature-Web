###
    Main router for the project
###

@Router = Backbone.Router.extend 
  routes :
    "signatures": "signatures"	
    "campaigns": "campaigns"		
    "account": "account"
    "services": "services"
    "dashboard": "dashboard"
    "users": "users"
    "images": "images"
    "subscription": "signup"
    "download": "download"
    "subscription/return/:reason": "subscription"
    "": "home"
    "*invalidRoute": "notFound" # For any other path, go 404
    

    # The current view
  view: null

    # Selector for the div that will contain each page
  page_parent_sel: "#content"

    # Selector for the container of the login component
  page_header_sel: "#header"

    # Google Analytics instance variable
  _gaq: null

    # Constructor
  initialize: () ->
    @renderHeader()

    # Methods for each route
  home: () ->
    @.go Home

  signatures: () ->
    @.go ViewSignatures, true, false

  campaigns: () ->
    @.go ViewCampaigns, true, false
        
  services: () ->
    @.go ViewServices, true, true
        
  account: () ->
    @.go ViewAccount, true, false
        
  dashboard: () ->
    @.go ViewDashboard, true, false
    
  images: () ->
    @.go ViewImages, true, false
    
  users: () ->
    @.go ViewUsers, true, true

  notFound: () ->
    @.go ViewNotFound, false

  signup: () ->
    @.go ViewSignup, true, false
  
  download: () ->
    @.go ViewDownload, false
    
  subscription: (reason) ->
    @.go ViewSubscription, false, false, reason

    # Actually changes the page by creating the view and inserting it
  go: (viewClass, internal, paid, params) ->
    if !viewClass?
      @navigate("/404", {trigger: true})
    
    if !internal # si c'est une page public
      @view = new viewClass(params)
      @render()
    else # si c'est une page privée
      if (Meteor.userId()? and Meteor.user()?) # on doit être connecté
        if !Meteor.user().profile.paid and !Meteor.user().profile.admin # si ce n'est pas un admin et qu'il ne paie pas
          @navigate("/subscription", {trigger: true})
        else 
          if !paid or Meteor.user().profile.admin # Si c'est une page non payante ou si l'on est admin
            @view = new viewClass(params)
            @render()
          else # si c'est une page payante et que l'on ne paie pas
            @navigate("/subscription", {trigger: true})
      else # si on est pas connecté et que c'est une page public
        @navigate("/404", {trigger: true})

    # Render the current view
  render: () ->
    $(".modal-backdrop").remove()
    $(".md-modal").removeClass("md-show")
    $(@page_parent_sel).html(@view.render().$el)
    $('#loading').hide();
    
  renderHeader: () ->
    @viewHeader = new ViewHeader()
    $(@page_header_sel).html(@viewHeader.render().$el)
    
    # Method to replace an anchor tag event with a Backbone route event
  aReplace: (e) ->
        # Don't let the page reload like normal 
    if @getHref(e.target).slice(-1) isnt "#" and !$(e.target).hasClass("no-backbone")
      $('#loading').show();
      e.preventDefault()
        # Parse out the part of the url the router needs
      a = document.createElement("a")
      a.href = @getHref(e.target)
      route = a.pathname + a.search
      
      if "/#{Backbone.history.getFragment()}" == route
        $('#loading').hide();
        
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