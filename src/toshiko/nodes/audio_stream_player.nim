# author: Ethosa
## AudioStreamPlayer used for playing audio.
## 
## AudioStream is responsible for audio. You can play multiple audio recordings at once.
import
  ../thirdparty/sdl2/mixer,
  ../core,
  node


type
  AudioStreamPlayerObj* {.final.} = object of NodeObj
    paused*: bool
    volume*: cint
    stream*: AudioStreamRef
  AudioStreamPlayerRef* = ref AudioStreamPlayerObj


proc AudioStreamPlayer*(name: string = "AudioStreamPlayer"): AudioStreamPlayerRef =
  ## Creates a new AudioStreamPlayer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var audio = AudioStreamPlayer("AudioStreamPlayer")
  nodepattern(AudioStreamPlayerRef)
  result.paused = false
  result.volume = 64
  result.kind = AUDIO_STREAM_PLAYER_NODE


method pause*(self: AudioStreamPlayerRef) {.base.} =
  ## Pauses stream.
  if playing(self.stream.channel) > -1:
    pause(self.stream.channel)

method play*(self: AudioStreamPlayerRef) {.base.} =
  ## Play stream.
  discard playChannel(
    self.stream.channel, self.stream.chunk,
    if self.stream.loop: -1 else: 1
  )

method resume*(self: AudioStreamPlayerRef) {.base.} =
  ## Resume stream.
  if paused(self.stream.channel) > -1:
    resume(self.stream.channel)

method setStream*(self: AudioStreamPlayerRef, newstream: AudioStreamRef) {.base.} =
  ## Changes stream.
  self.stream = newstream

method setStream*(self: AudioStreamPlayerRef, newstream: string) {.base.} =
  ## Loads audio from `newstream` file path.
  self.stream = loadAudio(newstream)

method setVolume*(self: AudioStreamPlayerRef, value: cint) {.base.} =
  ## Changes stream volume.
  ##
  ## Arguments:
  ## - `volume` is a number in range `0..128`.
  if value > 128:
    self.volume = 128
  elif value < 0:
    self.volume = 0
  else:
    self.volume = value
  discard volume(self.stream.channel, self.volume)
