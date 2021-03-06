metronome = require './metronome'
game = null

duplicates = {}
cast = {}
background = null
kick = null
wind = null
attacks = {}

create = (g) ->
  game = g
  background = game.add.audio 'background'
  kick = game.add.audio 'kick'

  # duplicates
  duplicates.earth = []
  duplicates.earth[1] = game.add.audio "duplicate.earth.1", 0
  duplicates.earth[2] = game.add.audio "duplicate.earth.2", 0
  duplicates.earth[3] = game.add.audio "duplicate.earth.3", 0
  duplicates.earth[4] = game.add.audio "duplicate.earth.4", 0

  duplicates.fire = []
  duplicates.fire[1] = game.add.audio "duplicate.fire.1", 0
  duplicates.fire[2] = game.add.audio "duplicate.fire.2", 0
  duplicates.fire[3] = game.add.audio "duplicate.fire.3", 0
  duplicates.fire[4] = game.add.audio "duplicate.fire.4", 0

  duplicates.water = []
  duplicates.water[1] = game.add.audio "duplicate.water.1", 0
  duplicates.water[2] = game.add.audio "duplicate.water.2", 0
  duplicates.water[3] = game.add.audio "duplicate.water.3", 0
  duplicates.water[4] = game.add.audio "duplicate.water.4", 0
  duplicates.water[5] = game.add.audio "duplicate.water.5", 0
  duplicates.water[6] = game.add.audio "duplicate.water.6", 0
  duplicates.water[7] = game.add.audio "duplicate.water.7", 0
  duplicates.water[8] = game.add.audio "duplicate.water.8", 0
  duplicates.water[9] = game.add.audio "duplicate.water.9", 0
  duplicates.water[10] = game.add.audio "duplicate.water.10", 0

  wind = game.add.audio 'duplicate.wind', 0
  ['water', 'wind', 'fire', 'earth'].forEach (element) ->
    attacks[element] = game.add.audio "attack.#{element}"

  # casting
  cast.succeed = game.add.audio 'cast.succeed'
  cast.fail = game.add.audio 'cast.fail'

patterns =
  water: [
    1
    2
    3
    4
    1
    2
    5
    4
    6
    2
    7
    8
    1
    2
    9
    10
  ]
  earth: [
    1
    2
    1
    2
    1
    2
    1
    3
    1
    2
    1
    2
    1
    2
    1
    4
  ]
  fire: [
    1
    1
    1
    1
    2
    2
    2
    2
    3
    3
    3
    3
    4
    4
    4
    4
  ]

currentMeasure =
  fire: 0
  earth: 0
  water: 0

getSound = (element, beat) ->
  n = patterns[element][currentMeasure[element]]
  sound = duplicates[element][n]
  currentMeasure[element] = currentMeasure[element] + 1
  currentMeasure[element] = currentMeasure[element] % 16
  sound

bgBeat = 0
bgLength = 4 * 64
windBeat = 0
windLength = 4 * 16
onBeat = (beat) ->
  background.play() if bgBeat is 0
  if beat is 0
    getSound(element, beat).play() for element in ['water', 'earth', 'fire']
  kick.play() if beat is 0
  wind.play() if windBeat is 0
  bgBeat++
  bgBeat = bgBeat % bgLength
  windBeat++
  windBeat = bgBeat % windBeat

load = (game) ->
  game.load.audio 'background', 'sound/bg.wav'
  game.load.audio 'kick', 'sound/kick.wav'

  # duplicates
  game.load.audio 'duplicate.fire.1', 'sound/Fire/Fire 1.wav'
  game.load.audio 'duplicate.fire.2', 'sound/Fire/Fire 2.wav'
  game.load.audio 'duplicate.fire.3', 'sound/Fire/Fire 3.wav'
  game.load.audio 'duplicate.fire.4', 'sound/Fire/Fire 4.wav'

  game.load.audio 'duplicate.earth.1', 'sound/Earth/Earth 1.wav'
  game.load.audio 'duplicate.earth.2', 'sound/Earth/Earth 2.wav'
  game.load.audio 'duplicate.earth.3', 'sound/Earth/Earth 3.wav'
  game.load.audio 'duplicate.earth.4', 'sound/Earth/Earth 4.wav'

  game.load.audio 'duplicate.water.1', 'sound/Water/Water 1.wav'
  game.load.audio 'duplicate.water.2', 'sound/Water/Water 2.wav'
  game.load.audio 'duplicate.water.3', 'sound/Water/Water 3.wav'
  game.load.audio 'duplicate.water.4', 'sound/Water/Water 4.wav'
  game.load.audio 'duplicate.water.5', 'sound/Water/Water 5.wav'
  game.load.audio 'duplicate.water.6', 'sound/Water/Water 6.wav'
  game.load.audio 'duplicate.water.7', 'sound/Water/Water 7.wav'
  game.load.audio 'duplicate.water.8', 'sound/Water/Water 8.wav'
  game.load.audio 'duplicate.water.9', 'sound/Water/Water 9.wav'
  game.load.audio 'duplicate.water.10', 'sound/Water/Water 10.wav'

  game.load.audio 'duplicate.wind', 'sound/wind.wav'

  # casting
  game.load.audio 'cast.succeed', 'sound/cast.mp3'
  game.load.audio 'cast.fail', 'sound/Miss.wav'

  game.load.audio 'attack.fire', 'sound/Attacks/Fire Attack.wav'
  game.load.audio 'attack.water', 'sound/Attacks/Water Attack.wav'
  game.load.audio 'attack.earth', 'sound/Attacks/Earth Attack.wav'
  game.load.audio 'attack.wind', 'sound/Attacks/Wind Attack.wav'

alreadyPlaying =
  fire: false
  water: false
  wind: false
  earth: false

duplicateSummoned = (element) ->
  if element is 'wind'
    wind.fadeIn 500
    return
  unless alreadyPlaying[element]
    duplicates[element].forEach (sound) ->
      sound.fadeIn 500
    alreadyPlaying[element] = true

castSucceed = ->
  cast.succeed.play()

castFail = ->
  cast.fail.play()

module.exports =
  load: load
  create: create
  onBeat: onBeat
  duplicateSummoned: duplicateSummoned
  cast:
    succeed: castSucceed
    fail: castFail
  attacks: (element) -> attacks[element]
