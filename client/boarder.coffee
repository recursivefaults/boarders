Session.setDefault("main_page", "canvas_page")

$ ->
  canvas = $('canvas')
  console.log "CANVAS"
  console.log canvas.length

Template.main_page.main = () ->
  user = Meteor.user()
  if(user?.profile.is_teacher and Session.get("main_page") == "canvas_page")
    console.log "Teacher page"
    return Template["teacher_page"]()
  Template[Session.get("main_page")]()

Template.heading.events
  'click #account-name': (event, template) ->
    Session.set("main_page", "account_page")
  'click #clear-button': (event, template) ->
    Meteor.call('wipeScreen')
    
Handlebars.registerHelper 'is_teacher', () ->
  return Meteor.user.profile.is_teacher?

Template.account_page.is_checked = () ->
  if Meteor.user()?.profile.is_teacher then "checked" else null

Template.account_page.events
  'click #save-button': (event, template) ->
    is_teacher = $("input#is_teacher").is(':checked')
    Meteor.users.update(Meteor.userId(), $set:{'profile.is_teacher': is_teacher})
    Session.set("main_page", "canvas_page")
  'click #sign-out-button': (event, template) ->
    Meteor.logout()
    Session.set("main_page", "canvas_page")

Template.teacher_page.events
  'submit': (event, template) ->
    Topics.remove({})
    Topics.insert({topic: template.find('input').value})

Template.teacher_page.non_teachers = () ->
  Meteor.users.find()

Template.tiny_canvas.user_name = () ->
  return @.profile.name
  

Template.tiny_canvas.rendered = (id) ->
  canvas = $(@.find('canvas'))
  return if canvas.length == 0
  ctx = canvas[0].getContext('2d')
  

  Deps.autorun () ->
    wipe ctx, canvas
    Lines.find(user_id: canvas.attr('id')).forEach((line) ->
      console.log "LINE"
      drawLine ctx, line.from, line.to, true
    )
  ctx.strokeStyle = '#ffffff'
  ctx.fillStyle = '#000000'

Template.canvas_page.topic = () ->
  return Topics.findOne()?.topic

Template.canvas.rendered = () ->
  canvas = $('canvas')
  return if canvas.length == 0
  ctx = canvas[0].getContext('2d')
  drawing = false
  from = null
  canvas.attr(
    width: $("#canvas-section").width()
    height: $("#canvas-section").height()
  )
  canvas.hammer().on('dragstart', (event) ->
    console.log "START"
    drawing = true;
    from = {x: parseInt(event.gesture.srcEvent.offsetX), y: parseInt(event.gesture.srcEvent.offsetY)}
  ).on('dragend', () ->
    drawing = false
  ).on('drag', (event) ->
    return if(!drawing)
    to = {x: parseInt(event.gesture.srcEvent.offsetX), y: parseInt(event.gesture.srcEvent.offsetY)}
    drawLine(ctx, from, to)
    user_id = Meteor.userId()
    Lines.insert({user_id: user_id, from: from, to: to})
    from = to
  )
  Deps.autorun(()->
  
    wipe(ctx, canvas)
  
    Lines.find(user_id: Meteor.userId()).forEach((line) -> 
      drawLine(ctx, line.from, line.to)
    )
  )
  ctx.strokeStyle = '#ffffff'
  ctx.fillStyle = '#000000'
  

wipe = (ctx, canvas) ->
  # ctx.canvas.width = ctx.canvas.width
  ctx.fillRect(0, 0, canvas.width(), canvas.height());

drawLine = (ctx, from, to, should_scale) ->
  scaleX = 1.0
  scaleY = 1.0
  if(should_scale)
    scaleX = ctx.canvas.width/800
    scaleY = ctx.canvas.height/600
    # console.log scaleX
  # console.log "FROM: #{parseInt(from.x * scaleX)}, #{parseInt(from.y * scaleY)}"
  # console.log "TO: #{parseInt(to.x * scaleX)}, #{parseInt(to.y * scaleY)}"
  ctx.beginPath()
  ctx.moveTo(parseInt(from.x * scaleX), parseInt(from.y * scaleY))
  ctx.lineTo(parseInt(to.x * scaleX), parseInt(to.y * scaleY))
  ctx.closePath()
  ctx.stroke()

Template.canvas.isTeacher = () ->
  true


