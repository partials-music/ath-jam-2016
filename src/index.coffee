Phaser = require './phaser'
metronome = require './metronome'
standingStones = require './standing-stones'
worshippers = require './worshippers'
player = require './player'
#midi = require './midi'
music = require './music'
duplicates = require './duplicates'
spawnPoints = require './spawn-points'
moveEnemies = require './move-enemies'
attack = require './attack'

GAME_WIDTH = $(window).width()
GAME_HEIGHT = $(window).height()

preload = ->
  game.load.image 'map', 'img/map1.png', 1, 1
  game.renderer.renderSession.roundPixels = true
  Phaser.Canvas.setImageRenderingCrisp this.game.canvas

  worshippers.load game
  player.load game
  standingStones.load game
  duplicates.load game
  moveEnemies.load game
  music.load game
  spawnPoints.load game
  attack.load game

met = null

base =
  x: 0.3
  y: 1

create = ->
  game.physics.startSystem Phaser.Physics.ARCADE
  background = game.add.sprite 0, 0, 'map'
  background.scale.set game.width / 5040, game.height / 3960
  # create modules
  standingStones.create game
  worshippers.create game
  music.create game
  met = metronome.create game
  player.create game
  duplicates.create game
  moveEnemies.create game, base, spawnPoints.s1, spawnPoints.s2
  spawnPoints.create game
  attack.create game

  # wire up event listeners
  met.add standingStones.onBeat
  met.add music.onBeat
  
  met.add duplicates.onBeat
  player.onCast.add worshippers.cast
  player.onCast.add duplicates.cast
  duplicates.summonSignal.add player.summon

update = ->
  worshippers.move metronome.progressThroughMeasure()
  player.move()
  spawnPoints.update()
  duplicates.update()
  attack.update()

render = ->

game = new Phaser.Game GAME_WIDTH, GAME_HEIGHT, Phaser.AUTO, '', preload: preload, create: create, update: update, render: render
