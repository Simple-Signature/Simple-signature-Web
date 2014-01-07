    var VALID_KEYS = [
    'dropdownVisible',

    // XXX consider replacing these with one key that has an enum for values.
    'inSignupFlow',
    'inForgotPasswordFlow',
    'inChangePasswordFlow',
    'inMessageOnlyFlow',

    'errorMessage',
    'infoMessage',

    // dialogs with messages (info and error)
    'resetPasswordToken',
    'enrollAccountToken',
    'justVerifiedEmail',

    'configureLoginServiceDialogVisible',
    'configureLoginServiceDialogServiceName',
    'configureLoginServiceDialogSaveDisabled'
  ];

  var validateKey = function (key) {
    if (!_.contains(VALID_KEYS, key))
      throw new Error("Invalid key in loginButtonsSession: " + key);
  };

  var KEY_PREFIX = "Meteor.loginButtons.";

  // XXX we should have a better pattern for code private to a package like this one
  Accounts._loginButtonsSession = {
    set: function(key, value) {
      validateKey(key);
      if (_.contains(['errorMessage', 'infoMessage'], key))
        throw new Error("Don't set errorMessage or infoMessage directly. Instead, use errorMessage() or infoMessage().");

      this._set(key, value);
    },

    _set: function(key, value) {
      Session.set(KEY_PREFIX + key, value);
    },

    get: function(key) {
      validateKey(key);
      return Session.get(KEY_PREFIX + key);
    },

    closeDropdown: function () {
      this.set('inSignupFlow', false);
      this.set('inForgotPasswordFlow', false);
      this.set('inChangePasswordFlow', false);
      this.set('inMessageOnlyFlow', false);
      this.set('dropdownVisible', false);
      this.resetMessages();
    },

    infoMessage: function(message) {
      console.log(message);
      this._set("errorMessage", null);
      this._set("infoMessage", message);
      this.ensureMessageVisible();
    },

    errorMessage: function(message) {
      this._set("errorMessage", message);
      this._set("infoMessage", null);
      this.ensureMessageVisible();
    },

    // is there a visible dialog that shows messages (info and error)
    isMessageDialogVisible: function () {
      return this.get('resetPasswordToken') ||
        this.get('enrollAccountToken') ||
        this.get('justVerifiedEmail');
    },

    // ensure that somethings displaying a message (info or error) is
    // visible.  if a dialog with messages is open, do nothing;
    // otherwise open the dropdown.
    //
    // notably this doesn't matter when only displaying a single login
    // button since then we have an explicit message dialog
    // (_loginButtonsMessageDialog), and dropdownVisible is ignored in
    // this case.
    ensureMessageVisible: function () {
      if (!this.isMessageDialogVisible())
      {
        this.set("dropdownVisible", true);
        $('#login').html(Meteor.render(Template._loginButtons));
      } 
    },

    resetMessages: function () {
      this._set("errorMessage", null);
      this._set("infoMessage", null);
    }
  };
  if (!Accounts._loginButtons)
        Accounts._loginButtons = {};

    // for convenience
    var loginButtonsSession = Accounts._loginButtonsSession;

    Handlebars.registerHelper(
        "loginButtons",
        function(options) {
            if (options.hash.align === "left")
                return new Handlebars.SafeString(Template._loginButtons({
                    align: "left"
                }));
            else
                return new Handlebars.SafeString(Template._loginButtons({
                    align: "right"
                }));
        });
    Template._loginButtons.rendered=function(){
      if(loginButtonsSession.get('dropdownVisible'))
        toggleDropdown();
    };
    // shared between dropdown and single mode
    Template._loginButtons.events({
        'click #login-buttons-logout': function() {
            Meteor.logout(function() {
                loginButtonsSession.closeDropdown();
                App.router.renderHeader();
                App.router.navigate("/", {trigger: true})
            });           
        }
    });

    Template._loginButtons.preserve({
        'input[id]': Spark._labelFromIdOrName
    });


    //
    // loginButtonsLoggedIn template
    //


    Template._loginButtonsLoggedIn.displayName = function() {
        return Accounts._loginButtons.displayName();
    };
    
    Template._loginButtonsLoggedIn.rendered = function() {
      Meteor.subscribe('services');
      Meteor.subscribe('signatures');
      Meteor.subscribe('campaigns');
      Meteor.subscribe('images');
      Meteor.subscribe('stats');
    };
      


    //
    // loginButtonsMessage template
    //

    Template._loginButtonsMessages.errorMessage = function() {
        return loginButtonsSession.get('errorMessage');
    };

    Template._loginButtonsMessages.infoMessage = function() {
        return loginButtonsSession.get('infoMessage');
    };
    
    //
    // helpers
    //

    Accounts._loginButtons.displayName = function() {
        var user = Meteor.user();
        
        if (user.emails && user.emails[0] && user.emails[0].address)
            return user.emails[0].address;

        return '';
    };
    
    Accounts._loginButtons.validateEmail = function(email) {
        
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        if (re.test(email)) {
          if(Meteor.users.find({emails:[{address:email}]}).count() !==0)
          {
            loginButtonsSession.errorMessage("Email already exists in the database");
            return false;
          }
          else
            return true;
        } else {
            loginButtonsSession.errorMessage("Invalid email");
            return false;
        }
    };
    Accounts._loginButtons.validatePassword = function(password) {
        if (password.length >= 6) {
            return true;
        } else {
            loginButtonsSession.errorMessage("Password must be at least 6 characters long");
            return false;
        }
    };
    
    Accounts._loginButtons.validateFirm = function(firm) {
        if (firm.length >= 2) {
          if(Firms.find({name:firm}).count()===0)
            return true;
          else
          {
            loginButtonsSession.errorMessage("A firm with that name already exists");
            return false;
          }            
        } else {
            loginButtonsSession.errorMessage("Firm's name must be at least 2 characters long");
            return false;
        }
    };

  //
  // loginButtonsLoggedInDropdown template and related
  //

  Template._loginButtonsLoggedInDropdown.events({
    'click #login-buttons-open-change-password': function(event) {
      event.stopPropagation();
      loginButtonsSession.resetMessages();
      loginButtonsSession.set('inChangePasswordFlow', true);
      loginButtonsSession.set('dropdownVisible', true);
      $('#login').html(Meteor.render(Template._loginButtons));
    }
  });

  Template._loginButtonsLoggedInDropdown.displayName = function () {
    return Accounts._loginButtons.displayName();
  };

  Template._loginButtonsLoggedInDropdown.inChangePasswordFlow = function () {
    return loginButtonsSession.get('inChangePasswordFlow');
  };

  Template._loginButtonsLoggedInDropdown.inMessageOnlyFlow = function () {
    return loginButtonsSession.get('inMessageOnlyFlow');
  };

  Template._loginButtonsLoggedInDropdown.dropdownVisible = function () {
    return loginButtonsSession.get('dropdownVisible');
  };

  Template._loginButtonsLoggedInDropdownActions.allowChangingPassword = function () {
    return true;
  };


  //
  // loginButtonsLoggedOutDropdown template and related
  //

  Template._loginButtonsLoggedOutDropdown.events({
    "submit #login-form" : function(e,t) {
      e.preventDefault();
      loginOrSignup();
    },

    'submit #forgot-form': function (event) {
      event.preventDefault();
      forgotPassword();
    },

    'click #signup-link': function (event) {
      event.preventDefault();
      loginButtonsSession.resetMessages();

      // store values of fields before swtiching to the signup form
      var email = trimmedElementValueById('login-email');
      // notably not trimmed. a password could (?) start or end with a space
      var password = elementValueById('login-password');

      loginButtonsSession.set('inSignupFlow', true);
      loginButtonsSession.set('inForgotPasswordFlow', false);
      loginButtonsSession.set('dropdownVisible', true);

      // force the ui to update so that we have the approprate fields to fill in
      $('#login').html(Meteor.render(Template._loginButtons));
      
      // update new fields with appropriate defaults
      if (email !== null)
        document.getElementById('login-email').value = email;
    },
    'click #forgot-password-link': function (event) {
      event.preventDefault();
      event.stopPropagation();
      loginButtonsSession.resetMessages();

      // store values of fields before swtiching to the signup form
      var email = trimmedElementValueById('login-email');

      loginButtonsSession.set('inSignupFlow', false);
      loginButtonsSession.set('inForgotPasswordFlow', true);
      loginButtonsSession.set('dropdownVisible', true);

      // force the ui to update so that we have the approprate fields to fill in
      $('#login').html(Meteor.render(Template._loginButtons));

      // update new fields with appropriate defaults
      if (email !== null)
        document.getElementById('forgot-password-email').value = email;
    },
    'click #back-to-login-link': function () {
    event.preventDefault();
      loginButtonsSession.resetMessages();

      var email = trimmedElementValueById('login-email')
            || trimmedElementValueById('forgot-password-email'); // Ughh. Standardize on names?

      loginButtonsSession.set('inSignupFlow', false);
      loginButtonsSession.set('inForgotPasswordFlow', false);
      loginButtonsSession.set('dropdownVisible', true);

      // force the ui to update so that we have the approprate fields to fill in
      $('#login').html(Meteor.render(Template._loginButtons));
      
      if (document.getElementById('login-email'))
        document.getElementById('login-email').value = email;
    }
  });

  Template._loginButtonsLoggedOutPasswordService.fields = function () {
    var loginFields = [
      {fieldName: 'email', fieldLabel: 'Email', inputType: 'email', visible: true},
      {fieldName: 'password', fieldLabel: 'Password', inputType: 'password', visible: true}
    ];

    var signupFields = [
      
      {fieldName: 'email', fieldLabel: 'Email', inputType: 'email', visible: true},
      {fieldName: 'firm', fieldLabel: 'Firm', inputType: 'text', visible: true},
      {fieldName: 'password', fieldLabel: 'Password', inputType: 'password', visible: true}
      
    ];

    return loginButtonsSession.get('inSignupFlow') ? signupFields : loginFields;
  };

  Template._loginButtonsLoggedOutPasswordService.inForgotPasswordFlow = function () {
    return loginButtonsSession.get('inForgotPasswordFlow');
  };

  Template._loginButtonsLoggedOutPasswordService.inLoginFlow = function () {
    return !loginButtonsSession.get('inSignupFlow') && !loginButtonsSession.get('inForgotPasswordFlow');
  };

  Template._loginButtonsLoggedOutPasswordService.inSignupFlow = function () {
    return loginButtonsSession.get('inSignupFlow');
  };

  Template._loginButtonsLoggedOutPasswordService.showForgotPasswordLink = function () {
    return true;
  };

  Template._loginButtonsLoggedOutPasswordService.showCreateAccountLink = function() {
    return true;
  };

  Template._loginButtonsFormField.inputType = function () {
    return this.inputType || "text";
  };


  //
  // loginButtonsChangePassword template
  //

  Template._loginButtonsChangePassword.events({
    'keypress #login-old-password, keypress #login-password, keypress #login-password-again': function (event) {
      if (event.keyCode === 13)
        changePassword();
    },
    'click #login-buttons-do-change-password': function (event) {
      event.stopPropagation();
      changePassword();
    }
  });

  Template._loginButtonsChangePassword.fields = function () {
    return [
      {fieldName: 'old-password', fieldLabel: 'Current Password', inputType: 'password',
       visible: function () {
         return true;
       }},
      {fieldName: 'password', fieldLabel: 'New Password', inputType: 'password',
       visible: function () {
         return true;
       }}
    ];
  };


  //
  // helpers
  //

  var elementValueById = function(id) {
    var element = document.getElementById(id);
    if (!element)
      return null;
    else
      return element.value;
  };

  var trimmedElementValueById = function(id) {
    var element = document.getElementById(id);
    if (!element)
      return null;
    else
      return element.value.replace(/^\s*|\s*$/g, ""); // trim;
  };

  var loginOrSignup = function () {
    if (loginButtonsSession.get('inSignupFlow'))
      signup();
    else
      login();
  };

  var login = function () {
    loginButtonsSession.resetMessages();

    var email = trimmedElementValueById('login-email');
    // notably not trimmed. a password could (?) start or end with a space
    var password = elementValueById('login-password');

    var loginSelector;
    
      if (!Accounts._loginButtons.validateEmail(email))
        return;
      else
        loginSelector = {email: email};

    Meteor.loginWithPassword(loginSelector, password, function (error, result) {
      if (error) {
        loginButtonsSession.errorMessage(error.reason || "Unknown error");
      } else {
        loginButtonsSession.closeDropdown();
        App.router.renderHeader();
        App.router.navigate("/dashboard", {trigger: true})
      }
    });
  };

  var toggleDropdown = function() {
    $(".dropdown-toggle").dropdown('toggle');
  };

  var signup = function () {
    loginButtonsSession.resetMessages();

    var options = {}; // to be passed to Accounts.createUser

    var email = trimmedElementValueById('login-email');
    if (!Accounts._loginButtons.validateEmail(email))
        return;
    else
        options.email = email;

    // notably not trimmed. a password could (?) start or end with a space
    var password = elementValueById('login-password');
    if (!Accounts._loginButtons.validatePassword(password))
      return;
    else
      options.password = password;

    if (!matchPasswordAgainIfPresent())
      return;
    
    var firm = trimmedElementValueById('login-firm');
    if (!Accounts._loginButtons.validateFirm(firm))
      return;
    else
    {
      var firmId = Firms.insert({name: firm});
      var valueInt = "<p style=\"font-family: Helvetica, Arial, sans-serif; font-size: 12px; line-height: 14px; color: rgb(153, 153, 153);\"><span style=\"font-weight: bold; color: rgb(24, 74, 147);\">VARIABLE_NAME</span> / <span style=\"color: rgb(24, 74, 147);\">VARIABLE_JOB</span><br><span style=\"color: rgb(24, 74, 147);\">VARIABLE_PHONE / <a href=\"mailto:VARIABLE_MAIL\" style=\"color: rgb(30, 177, 230);\">VARIABLE_MAIL</a><span></p>";
      var signInt = Signatures.insert({name: "interne default",firm: firmId,createdAt: new Date(),value : valueInt});
      var valueExt = "<p style=\"font-family: Helvetica, Arial, sans-serif; font-size: 12px; line-height: 14px; color: rgb(153, 153, 153);\"><span style=\"font-weight: bold; color: rgb(24, 74, 147);\">VARIABLE_NAME</span> / <span style=\"color: rgb(24, 74, 147);\">VARIABLE_JOB</span><br><span style=\"color: rgb(24, 74, 147);\">VARIABLE_PHONE / <a href=\"mailto:VARIABLE_MAIL\" style=\"color: rgb(30, 177, 230);\">VARIABLE_MAIL</a><span></p><p style=\"font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 14px;\"><span style=\"font-weight: bold; color: rgb(24, 74, 147);\">"+firm+"</span></p>";
      var signExt = Signatures.insert({name: "externe default",firm: firmId,createdAt: new Date(),value : valueExt});
      Campaigns.insert({title:"Default Intern",signature: signInt,firm: firmId,service: null,start: new Date(),end: new Date(2099,1,1),editable:false});
      Campaigns.insert({title:"Default Extern",signature: signExt,firm: firmId,service: null,start: new Date(),end: new Date(2099,1,1),editable:false});
      $('#previewSignature').html(valueInt);
      html2canvas($('#previewSignature'),{onrendered: function (canvas) {
        data = canvas.toDataURL(); 
        Signatures.update({_id:signInt},{$set:{img:data}})
        $('#previewSignature').html(valueExt);
        html2canvas($('#previewSignature'),{onrendered: function (canvas2) {
          data2 = canvas2.toDataURL(); 
          Signatures.update({_id:signExt},{$set:{img:data2}})
          $('#previewSignature').html('');
          }
        });
        }
      });        
      options.profile = {};
      options.profile.firm = firmId;
    }        
    options.profile.paid=false;
    options.profile.admin=true;

    Accounts.createUser(options, function (error) {
      if (error) {
        loginButtonsSession.errorMessage(error.reason || "Unknown error");
      } else {
        loginButtonsSession.closeDropdown();
        App.router.renderHeader();
        App.router.navigate("/dashboard", {trigger: true})
      }
    });
  };

  var forgotPassword = function () {
    loginButtonsSession.resetMessages();

    var email = trimmedElementValueById("forgot-password-email");
    if (email.indexOf('@') !== -1) {
      Accounts.forgotPassword({email: email}, function (error) {
        if (error)
          loginButtonsSession.errorMessage(error.reason || "Unknown error");
        else
          loginButtonsSession.infoMessage("Email sent");
      });
    } else {
      loginButtonsSession.infoMessage("Email sent");
    }
  };

  var changePassword = function () {
    loginButtonsSession.resetMessages();

    // notably not trimmed. a password could (?) start or end with a space
    var oldPassword = elementValueById('login-old-password');

    // notably not trimmed. a password could (?) start or end with a space
    var password = elementValueById('login-password');
    if (!Accounts._loginButtons.validatePassword(password))
      return;

    if (!matchPasswordAgainIfPresent())
      return;

    Accounts.changePassword(oldPassword, password, function (error) {
      if (error) {
         loginButtonsSession.errorMessage(error.reason || "Unknown error");
      } else {
        loginButtonsSession.infoMessage("Password changed");

        // wait 3 seconds, then expire the msg
        Meteor.setTimeout(function() {
          loginButtonsSession.resetMessages();
        }, 3000);
      }
    });
  };

  var matchPasswordAgainIfPresent = function () {
    // notably not trimmed. a password could (?) start or end with a space
    var passwordAgain = elementValueById('login-password-again');
    if (passwordAgain !== null) {
      // notably not trimmed. a password could (?) start or end with a space
      var password = elementValueById('login-password');
      if (password !== passwordAgain) {
        loginButtonsSession.errorMessage("Passwords don't match");
        return false;
      }
    }
    return true;
  };


  // XXX from http://epeli.github.com/underscore.string/lib/underscore.string.js
  var capitalize = function(str){
    str = str == null ? '' : String(str);
    return str.charAt(0).toUpperCase() + str.slice(1);
  };


  //
  // populate the session so that the appropriate dialogs are
  // displayed by reading variables set by accounts-urls, which parses
  // special URLs. since accounts-ui depends on accounts-urls, we are
  // guaranteed to have these set at this point.
  //

  if (Accounts._resetPasswordToken) {
    loginButtonsSession.set('resetPasswordToken', Accounts._resetPasswordToken);
  }

  if (Accounts._enrollAccountToken) {
    loginButtonsSession.set('enrollAccountToken', Accounts._enrollAccountToken);
  }

  // Needs to be in Meteor.startup because of a package loading order
  // issue. We can't be sure that accounts-password is loaded earlier
  // than accounts-ui so Accounts.verifyEmail might not be defined.
  Meteor.startup(function () {
    if (Accounts._verifyEmailToken) {
      Accounts.verifyEmail(Accounts._verifyEmailToken, function(error) {
        Accounts._enableAutoLogin();
        if (!error)
          loginButtonsSession.set('justVerifiedEmail', true);
        // XXX show something if there was an error.
      });
    }
  });


  //
  // resetPasswordDialog template
  //
  Template._resetPasswordDialog.rendered = function() {
    var $modal = $(this.find('#login-buttons-reset-password-modal'));
    $modal.modal();
  }

  Template._resetPasswordDialog.events({
    'click #login-buttons-reset-password-button': function () {
      resetPassword();
    },
    'keypress #reset-password-new-password': function (event) {
      if (event.keyCode === 13)
        resetPassword();
    },
    'click #login-buttons-cancel-reset-password': function () {
      loginButtonsSession.set('resetPasswordToken', null);
      Accounts._enableAutoLogin();
      $('#login-buttons-reset-password-modal').modal("hide");
    }
  });

  var resetPassword = function () {
    loginButtonsSession.resetMessages();
    var newPassword = document.getElementById('reset-password-new-password').value;
    if (!Accounts._loginButtons.validatePassword(newPassword))
      return;

    Accounts.resetPassword(
      loginButtonsSession.get('resetPasswordToken'), newPassword,
      function (error) {
        if (error) {
          loginButtonsSession.errorMessage(error.reason || "Unknown error");
        } else {
          loginButtonsSession.set('resetPasswordToken', null);
          Accounts._enableAutoLogin();
          $('#login-buttons-reset-password-modal').modal("hide");
        }
      });
  };

  Template._resetPasswordDialog.inResetPasswordFlow = function () {
    return loginButtonsSession.get('resetPasswordToken');
  };


  //
  // enrollAccountDialog template
  //

  Template._enrollAccountDialog.events({
    'click #login-buttons-enroll-account-button': function () {
      enrollAccount();
    },
    'keypress #enroll-account-password': function (event) {
      if (event.keyCode === 13)
        enrollAccount();
    },
    'click #login-buttons-cancel-enroll-account-button': function () {
      loginButtonsSession.set('enrollAccountToken', null);
      Accounts._enableAutoLogin();
      $modal.modal("hide");
    }
  });

  Template._enrollAccountDialog.rendered = function() {
    $modal = $(this.find('#login-buttons-enroll-account-modal'));
    $modal.modal();
  };

  var enrollAccount = function () {
    loginButtonsSession.resetMessages();
    var password = document.getElementById('enroll-account-password').value;
    if (!Accounts._loginButtons.validatePassword(password))
      return;

    Accounts.resetPassword(
      loginButtonsSession.get('enrollAccountToken'), password,
      function (error) {
        if (error) {
          loginButtonsSession.errorMessage(error.reason || "Unknown error");
        } else {
          loginButtonsSession.set('enrollAccountToken', null);
          Accounts._enableAutoLogin();
          $modal.modal("hide");
        }
      });
  };

  Template._enrollAccountDialog.inEnrollAccountFlow = function () {
    return loginButtonsSession.get('enrollAccountToken');
  };


  //
  // justVerifiedEmailDialog template
  //

  Template._justVerifiedEmailDialog.events({
    'click #just-verified-dismiss-button': function () {
      loginButtonsSession.set('justVerifiedEmail', false);
    }
  });

  Template._justVerifiedEmailDialog.visible = function () {
    return loginButtonsSession.get('justVerifiedEmail');
  };


  //
  // loginButtonsMessagesDialog template
  //

  // Template._loginButtonsMessagesDialog.rendered = function() {
  //   var $modal = $(this.find('#configure-login-service-dialog-modal'));
  //   $modal.modal();
  // }

  Template._loginButtonsMessagesDialog.events({
    'click #messages-dialog-dismiss-button': function () {
      loginButtonsSession.resetMessages();
    }
  });

  Template._loginButtonsMessagesDialog.visible = function () {
    var hasMessage = loginButtonsSession.get('infoMessage') || loginButtonsSession.get('errorMessage');
    return hasMessage;
  };