# author: Ethosa
import
  core/color


type
  EnvironmentRef* = ref object
    delay*: int
    background_color*: ColorRef
