Meteor.startup () ->
  Accounts.emailTemplates.siteName = config.app_name
  Accounts.emailTemplates.from = config.app_name+' Admin<'+config.email_admin+'>'

  Accounts.emailTemplates.enrollAccount.subject = (user)->
    return 'Activate your '+config.app_name+' account.'

    Accounts.emailTemplates.enrollAccount.html = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=signup&utm_medium=email&utm_campaign=signup&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to activate your "+config.app_name+" account.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Activate Account</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "
  Accounts.emailTemplates.enrollAccount.text = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=signup&utm_medium=email&utm_campaign=signup&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to activate your "+config.app_name+" account.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Activate Account</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "
  Accounts.emailTemplates.resetPassword.subject = (user)->
    return 'Reset your '+config.app_name+' password.'
  Accounts.emailTemplates.resetPassword.text = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=reset_password&utm_medium=email&utm_campaign=reset_password&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to reset your "+config.app_name+" password.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Reset Password</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "
  Accounts.emailTemplates.resetPassword.html = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=reset_password&utm_medium=email&utm_campaign=reset_password&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to reset your "+config.app_name+" password.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Reset Password</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "
  Accounts.emailTemplates.verifyEmail.subject = (user)->
    return 'Verify your '+config.app_name+' email.'
  Accounts.emailTemplates.verifyEmail.text = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=verify_email&utm_medium=email&utm_campaign=verify_email&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to verify your "+config.app_name+" email.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Verify Email</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "
  Accounts.emailTemplates.verifyEmail.html = (user, url)->
    return "
          <div style='background-color:#f2f2f2'>
            <center>
              <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%' style='background-color:#f2f2f2'>
                <tbody>
                  <tr>
                    <td align='center' valign='top' style='padding:40px 20px'>
                      <table border='0' cellpadding='0' cellspacing='0' style='width:600px'>
                        <tbody>
                          <tr>
                            <td align='center' valign='top'>
                              <a href='"+config.url+"/?utm_source=verify_email&utm_medium=email&utm_campaign=verify_email&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
                                <img src='"+config.url+"/img/S-logo-80.png' alt='"+config.app_name+"' height='' width='60' style='border:0;min-height:auto!important;line-height:100%;outline:none;text-align:center;text-decoration:none'>
                              </a>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top' style='padding-top:30px;padding-bottom:30px'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color:#ffffff;border-collapse:separate!important;border-radius:4px'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:15px;line-height:150%;padding-top:40px;padding-right:40px;padding-bottom:30px;padding-left:40px;text-align:center'>
                                      <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>Just one more step...</h1>
                                      <br>
                                      <h3 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:18px;letter-spacing:-.5px;line-height:115%;margin:0;padding:0;text-align:center'>#{user.emails[0].address}</h3>
                                      <br>
                                      Click the big button below to verify your "+config.app_name+" email.
                                    </td>
                                  </tr>
                                  <tr>
                                    <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                      <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                        <tbody>
                                          <tr>
                                            <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                              <a href='#{url}' style='color:#ffffff;text-decoration:none' target='_blank'>Verify Email</a>
                                            </td>
                                          </tr>
                                        </tbody>
                                      </table>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align='center' valign='top'>
                              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                <tbody>
                                  <tr>
                                    <td align='center' valign='top' style='color:#606060;font-family:Helvetica,Arial,sans-serif;font-size:13px;line-height:125%'>
                                      © 2014 "+config.app_name+", All Rights Reserved.
                                      <br>
                                      <span style='color:#606060!important'>82 Rue du bois de la Casse • Bourgoin Jallieu, 38300 FRANCE</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </center>
          </div>
         "