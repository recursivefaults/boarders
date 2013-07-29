Accounts.loginServiceConfiguration.remove({
    service: "google"
})

googleClientId = Meteor.settings.googleClientId
googleSecret = Meteor.settings.googleSecret

#insert localhost values if there's nothing in settings
if !googleClientId 
  googleClientId = "739728247473.apps.googleusercontent.com"
if !googleSecret
  googleSecret = "cPjLNV9fRC_ySq_5u_AefMnk"
  
Accounts.loginServiceConfiguration.insert({
    service: "google",
    clientId: googleClientId,
    secret: googleSecret
})