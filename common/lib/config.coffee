@config = 
  app_name: 'Simple Signature'
  url: 'http://simplesignature.meteor.com'
  ga: 'UA-37793536-1'
  email_admin: 'mathieu@dutour.me'
  email_notificator: 'no-reply@simplesignature.com'
  
if Meteor.isServer
  config.password_admin = 'dutour'

if Meteor.isClient
  Handlebars.registerHelper('config', (x) -> 
    return config[x]
  ) 