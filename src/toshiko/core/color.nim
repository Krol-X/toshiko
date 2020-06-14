# author: Ethosa
import
  strutils,
  re


type
  ColorObj* = object
    r*, g*, b*, a*: float
  ColorRef* = ref ColorObj



proc Color*(r, g, b, a: float): ColorRef =
  ColorRef(r: r, g: g, b: b, a: a)

proc Color*(r, g, b: float): ColorRef =
  Color(r, g, b, 1)

proc Color*(rgb: float): ColorRef =
  Color(rgb, rgb, rgb, 1)

proc Color*(clr: ColorRef): ColorRef =
  Color(clr.r, clr.g, clr.b, clr.a)

proc Color*: ColorRef =
  Color(0, 0, 0, 0)

proc Color*(r, g, b, a: int): ColorRef =
  Color(r / 255, g / 255, b / 255, a / 255)

proc Color*(r, g, b: int, a: float): ColorRef =
  Color(r / 255, g / 255, b / 255, a)

proc Color*(r, g, b: int): ColorRef =
  Color(r, g, b, 255)

proc Color*(hexint: int): ColorRef =
  Color(
    ((hexint shr 24) and 255) / 255,
    ((hexint shr 16) and 255) / 255,
    ((hexint shr 8) and 255) / 255,
    (hexint and 255) / 255
  )

proc Color*(hexstr: string): ColorRef =
  var target = hexstr
  var matched: array[20, string]

  # #FFFFFFFF, #FFF, #FFFFFF, etc
  if target.startsWith('#') or target.startsWith("0x") or target.startsWith("0X"):
    target = target[1..^1]
    if target[0] == 'x' or target[0] == 'X':
      target = target[1..^1]

    if target.len() == 3:  # #fff -> #ffffffff
      target = target[0] & target[0] & target[1] & target[1] & target[2] & target[2] & "ff"
    elif target.len() == 6:  # #ffffff -> #ffffffff
      target &= "ff"
    return Color(parseHexInt(target))

  # rgba(255, 255, 255, 1.0)
  elif target.match(re"\A\s*rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+.?\d*?)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]), parseInt(matched[1]), parseInt(matched[2]), parseFloat(matched[3]))

  # rgb(255, 255, 255)
  elif target.match(re"\A\s*rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]), parseInt(matched[1]), parseInt(matched[2]))


proc normalize*(a: ColorRef) =
  ## Normalizes color.
  runnableExamples:
    var clr = Color(-1f, 0.2, 10f)
    assert clr == Color(0f, 0.2, 1f)
  a.r = if a.r > 1f: 1f elif a.r < 0f: 0f else: a.r
  a.g = if a.g > 1f: 1f elif a.g < 0f: 0f else: a.g
  a.b = if a.b > 1f: 1f elif a.b < 0f: 0f else: a.b
  a.a = if a.a > 1f: 1f elif a.a < 0f: 0f else: a.a

proc normalized*(a: ColorRef): ColorRef =
  result = Color(a)
  result.normalize


proc `$`*(a: ColorRef): string =
  "Color(" & $a.r & ", " & $a.g & ", " & $a.b & ", " & $a.a & ")"

proc `==`*(a, b: ColorRef): bool =
  a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a

