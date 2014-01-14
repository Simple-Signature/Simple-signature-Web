class Meteor.Cron
  delay:1000*60
  events:[]

  constructor:(options)->
    @delay = options.delay if options?.delay
    @convert(options.events) if options?.events
    @do()
    @watch()

  convert:(events)->
    self = @
    for event of events
      cron = event.split(/\s/)

      isMin = 1 if cron[0] >= 0 and cron[0] <= 59 or cron[0] is '*'
      isHour = 1 if cron[1] >= 0 and cron[1] <= 23 or cron[1] is '*'
      isDate = 1 if cron[2] >= 0 and cron[2] <= 31 or cron[2] is '*'
      isMon = 1 if cron[3] >= 0 and cron[3] <= 12 or cron[3] is '*'
      isDay = 1 if cron[4] >= 0 and cron[4] <= 6 or cron[4] is '*'

      if (isMin &&  isHour && isDate && isMon && isDay)
        self.events.push
          cron:cron
          func:events[event]

  watch:()->
    self = @
    Meteor.setInterval ()->
      self.do()
    , self.delay

  doEvent:(event)->
    cron = event.cron
    isMin = 1       if cron[0] is "" + @now.getMinutes() or cron[0] is '*'
    isHour = 1      if cron[1] is "" + @now.getHours() or cron[1] is '*'
    isDate = 1      if cron[2] is "" + @now.getDate() or cron[2] is '*'
    isMon = 1       if cron[3] is "" + @now.getMonth() or cron[3] is '*'
    isDay = 1       if cron[4] is "" + @now.getDay() or cron[4] is '*'

    if (isMin &&  isHour && isDate && isMon && isDay)
      event.func()

  do:()->
    @now = new Date()
    for event in @events
      @doEvent event

new Meteor.Cron
  events:
    "0 0 * * *" : notifyCampaigns

notifyCampaigns = () ->
  now = new Date()
  campaigns = Campaigns.find({$and:[{notify:true},{start:{$gte: now}},{start:{$lt: now+86400000}}]})
  campaigns.forEach (campaign) ->
    users = Meteor.users.find({'profile.firm':campaign.firm})
    users.forEach (user) ->
      if user? and user.emails? and users.emails[0]? and user.emails[0].address
        Email.send
          to: user.emails[0].address
          from: config.app_name+" Notificator<"+config.email_notificator+">"
          subject: '"'+campaign.title+'"' + ' starts today.'
          html: "
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
                                      <a href='"+config.url+"/?utm_source=notifycampaigns&utm_medium=email&utm_campaign=notifycampaigns&utm_content=logo_top' title='"+config.app_name+"' style='text-decoration:none' target='_blank'>
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
                                              <h1 style='color:#606060!important;font-family:Helvetica,Arial,sans-serif;font-size:40px;font-weight:bold;letter-spacing:-1px;line-height:115%;margin:0;padding:0;text-align:center'>The '#{campaign.title}' campaign is about to start.</h1>
                                              <br>
                                              <br>
                                              Click the big button below to see the campaign on your dashboard.
                                            </td>
                                          </tr>
                                          <tr>
                                            <td align='center' valign='middle' style='padding-right:40px;padding-bottom:40px;padding-left:40px'>
                                              <table border='0' cellpadding='0' cellspacing='0' style='background-color:#9b59b6;border-collapse:separate!important;border-radius:3px;border-color:#8e44ad;'>
                                                <tbody>
                                                  <tr>
                                                    <td align='center' valign='middle' style='color:#ffffff;font-family:Helvetica,Arial,sans-serif;font-size:15px;font-weight:bold;line-height:100%;padding-top:18px;padding-right:15px;padding-bottom:15px;padding-left:15px'>
                                                      <a href='"+config.url+"/dashboard/?utm_source=notifycampaigns&utm_medium=email&utm_campaign=notifycampaigns&utm_content=bigbutton' style='color:#ffffff;text-decoration:none' target='_blank'>Go to the dashboard</a>
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
