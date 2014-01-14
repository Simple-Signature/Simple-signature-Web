###
    The main server file, general server side code should go here
###
  
# Set permissions on the users collection
Meteor.users.allow
    # A user can update their own record
  insert: (userId, doc) ->
    if userId == doc._id
      return true
    else 
      currentUser = Meteor.users.findOne(userId)
      firmIdAdmin = doc.profile.firm
      return currentUser.firm is firmIdAdmin and currentUser.profile.admin and current.profile.paid
  update: (userId, doc, fieldname) ->
    if userId == doc._id
      return fieldname.indexOf('profile.paid') is -1 and fieldname.indexOf('profile.admin') is -1
    else 
      currentUser = Meteor.users.findOne(userId)
      firmIdAdmin = doc.profile.firm
      return currentUser.firm is firmIdAdmin and currentUser.profile.admin and fieldname.indexOf('profile.paid') is -1 and fieldname.indexOf('profile.admin') is -1    
  remove: (userId, doc) ->
    if userId == doc._id
      return true
    else 
      currentUser = Meteor.users.findOne(userId)
      firmIdAdmin = doc.profile.firm
      return currentUser.firm is firmIdAdmin and currentUser.profile.admin

Meteor.methods
  createUserServerSide: (mail) ->
    if @userId
      user = Meteor.users.findOne(@userId)
      if user.profile.admin? and user.profile.paid? and user.profile.firm?
        id = Accounts.createUser
          email: mail
          profile:
            firm: user.profile.firm
            admin: false
            paid: true
            lang: user.profile.lang
        if id?
          Accounts.sendEnrollmentEmail id