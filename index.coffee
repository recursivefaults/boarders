@Lines = new Meteor.Collection('lines')
@Topics = new Meteor.Collection('topics')

Meteor.methods(
  wipeScreen: () ->
    Lines.remove({user_id: Meteor.userId()})
)