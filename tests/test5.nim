# --- Test 5. Use Color object. --- #
import toshiko


var
  rgba = Color("rgba(255, 255, 255, 0.8525)")
  rgb = Color("rgb(255, 255, 255)")
  hexstr = Color("#F0F")
  hexint = Color(0xFF00FFFF'i32)

assert rgba == Color(255, 255, 255, 0.8525)
assert rgb == Color(255, 255, 255)
assert hexstr == Color(255, 0, 255)
assert hexint == hexstr
