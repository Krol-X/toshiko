# author: Ethosa
import
  core/color


type
  ScreenMode* {.pure.} = enum
    SCREEN_MODE_NONE,  ## default mode.
    SCREEN_MODE_EXPANDED  ## Keep screen size.
  EnvironmentRef* = ref object
    delay*: int  ## FPS (60 FPS == 1000 div 60)
    background_color*: ColorRef  ## Background color.
    screen_mode*: ScreenMode

var env* = EnvironmentRef(delay: 17, background_color: Color("#333"), screen_mode: SCREEN_MODE_NONE)

proc setBackgroundColor*(color: ColorRef) =
  ## Changes screen background color.
  env.background_color = color

proc setFps*(fps: int) =
  ## Changes FPS.
  env.delay = 1000 div fps

proc setScreenMode*(mode: ScreenMode) =
  ## Changes screen mode.
  ## `mode` should be `SCREEN_MODE_NONE` or `SCREEN_MODE_EXPANDED`.
  env.screen_mode = mode
