@Lines = new Meteor.Collection('lines')

Meteor.methods(
  wipeScreen: () ->
    console.log "BERP"
    Lines.remove({})
)