
Meteor.startup(() ->
  canvas = $('canvas')
  ctx = canvas[0].getContext('2d')
  console.log ctx
  drawing = false
  from = null
  canvas.attr(
    width: $("#canvas-section").width()
    height: $("#canvas-section").height()
  )
  canvas.hammer().on('dragstart', (event) ->
    console.log "START"
    drawing = true;
    console.log event
    from = {x: parseInt(event.gesture.srcEvent.offsetX), y: parseInt(event.gesture.srcEvent.offsetY)}
  ).on('dragend', () ->
    console.log "END"
    drawing = false
  ).on('drag', (event) ->
    return if(!drawing)
    console.log "DRAW DRAW DRAW"
    to = {x: parseInt(event.gesture.srcEvent.offsetX), y: parseInt(event.gesture.srcEvent.offsetY)}
    drawLine(ctx, from, to)
    Lines.insert({from: from, to: to})
    from = to
  )
  wipe = (ctx) ->
    ctx.fillRect(0, 0, canvas.width(), canvas.height());
  
  Meteor.autorun( ()->

    wipe(ctx)

    Lines.find().forEach((line) -> 
      drawLine(ctx, line.from, line.to)
    )
  )
  
  ctx.strokeStyle = '#ffffff'
  ctx.fillStyle = '#000000'
  
  drawLine = (ctx, from, to) ->
    ctx.beginPath()
    ctx.moveTo(from.x, from.y)
    ctx.lineTo(to.x, to.y)
    ctx.closePath()
    ctx.stroke()
)


