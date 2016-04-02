metronome = require './metronome'
duplicates = require './duplicates'
mana = require './mana'
music = require './music'

player = null
cursors = null
SPEED = 300
onCast = new Phaser.Signal()
manaCosts =
  fire: 10
  water: 10
  earth: 10
  wind: 10

cast = ->
  hitInfo = metronome.isHit()
  if hitInfo?
    onCast.dispatch hitInfo...

create = (game) ->
  # sprite
  player = game.add.sprite 200, 200, 'player'
  player.scale.set 50, 50

  mana.create game

  # physics
  game.physics.arcade.enable player
  player.body.bounce.y = 0.2
  player.body.collideWorldBounds = true

  # animation
  player.animations.add 'left', [0, 1, 2], 10, true
  player.animations.add 'right', [3, 4, 5], 10, true
  player.animations.add 'up', [0, 1, 2], 10, true
  player.animations.add 'down', [0, 1, 2], 10, true

  player.animations.add 'summon.fire', [3, 4, 5], 10, false
  player.animations.add 'summon.water', [3, 4, 5], 10, false
  player.animations.add 'summon.wind', [3, 4, 5], 10, false
  player.animations.add 'summon.earth', [3, 4, 5], 10, false
  cursors = game.input.keyboard.createCursorKeys()

  # input
  space = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
  space.onDown.add cast

movementScheme =
  left:
    dimension: 'x'
    speed: -SPEED
  right:
    dimension: 'x'
    speed: SPEED
  up:
    dimension: 'y'
    speed: -SPEED
  down:
    dimension: 'y'
    speed: SPEED

getPressedDirections = (keys) ->
  pressed = (direction for own direction, key of keys when key.isDown)
  pressed

move = ->
  player.body.velocity.x = 0
  player.body.velocity.y = 0

  # scale back speed in each direction
  # if player is pressing more than
  # one key
  pressed = getPressedDirections cursors
  divisor = pressed.length + 1
  pressed.forEach (direction) ->
    scheme = movementScheme[direction]
    player.body.velocity[scheme.dimension] = scheme.speed / divisor
    player.animations.play direction
  if pressed.length is 0
    # stand still
    player.animations.stop()
    player.frame = 4

summon = (element) ->
  cost = manaCosts[element]
  if (mana.current() - cost) > 0
    player.animations.play "summon.#{element}"
    mana.spend cost
    duplicates.spawn element, player.body.position
    music.duplicateSummoned element

module.exports =
  create: create
  move: move
  sprite: -> player
  onCast: onCast
  summon: summon
