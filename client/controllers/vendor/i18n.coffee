@i18n = 
  setLocale: (locale) ->
    window.localStorage.setItem '_TranslatorService.locale', locale
    if Meteor.user()? and Meteor.user().profile.lang? and Meteor.user().profile.lang isnt locale
      Meteor.users.update(Meteor.userId,$set:{'profile.lang':locale})
    Session.set('_TranslatorService.locale', locale)
  getLocale: ->
    if Meteor.user()? and Meteor.user().profile.lang? and Meteor.user().profile.lang isnt locale
      Meteor.user().profile.lang
    else
      Session.get('_TranslatorService.locale')
  
class i18n._TranslatorService
  _DEFAULT_LOCALE: 'en'

  constructor: ->

    resolveParams = (message, params) ->
      for key, value of params
        regexp = new RegExp('\\{\\{' + key + '\\}\\}', 'g')
        message = message.replace regexp, value
      message

    retrieveMessage = (messageId) =>
      # We may have to recurse if the message id contains
      # a dot.
      messageParts = messageId.split('.')
      messageId = messageParts.pop()
      messages = i18n.i18nMessages
      messages = messages[messageParts]
      #while messageParts.length
        # Resolve the message namespace.
        #messages = messages[messageParts.shift()]
      
        # Does the message namespace exist?
      unless _.isObject(messages)
        throw Error '_meteor.translator.missingMessageNamespace'

      # Does the message have a translation?
      message = messages[messageId]
      throw Error '_meteor.translator.missingMessage' unless message?

      # Is this a cross-language message?
      return message if _.isString(message)

      # Do we have a language-specific message?
      locale = Session.get('_TranslatorService.locale') || @_DEFAULT_LOCALE

      message = message[locale]

      return message if _.isString(message)

      # Do we have a locale-specific message.
      return message[territory] if _.isString(message?[territory])

      # Try to fall back to the default territory.
      return message.default if _.isString(message?.default)

      # Hm, we have an error in the message structure.
      throw Error '_meteor.translator.unknownMessageFormat'

    # This is the actual service function.
    @translate = (messageId, params = {}) ->
      try
        # Retrieve the message.
        message = retrieveMessage(messageId)

        # Resolve message parameters.
        resolveParams(message, params)
      catch translationError
        errorMessageId = translationError.message
        errorMessage =
          try
            resolveParams(
              retrieveMessage(errorMessageId),
              messageId: messageId
            )
          catch e
            # Give up and display a generic error message in English
            # to avoid infinite recursion.
            """
            Translation Error: Cannot resolve error
            message '#{errorMessageId}' while translating '#{messageId}'
            """.replace /\n/, ' '
        console.log errorMessage
        '###' + messageId + '###'

    localLocale = window.localStorage.getItem '_TranslatorService.locale'
    if localLocale then i18n.setLocale localLocale

i18n._TranslatorService = i18n._ = new i18n._TranslatorService


# Public message configuration with system messages.
i18n.i18nMessages = {} unless i18n.i18nMessages?
i18n.i18nMessages._meteor = {} unless i18n.i18nMessages._meteor?
i18n.i18nMessages._meteor.translator =
  missingMessageNamespace:
    """
    Translation error: The message namespace of "{{messageId}}" cannot
    be resolved.
    """.replace /\n/, ' '
  missingMessage:
    """
    Translation error: The translation message "{{messageId}}" is
    missing in its message namespace.
    """.replace /\n/, ' '
  unknownMessageFormat:
    'Translation error: Unknown message format for "{{messageId}}".'

Handlebars.registerHelper('i18n', (x) -> 
  return i18n._.translate x
)