# author: Ethosa
import
  vector2


type
  Rect2Ref* = ref object
    x*, y*, w*, h*: float


proc Rect2*(x, y, w, h: float): Rect2Ref =
  Rect2Ref(x: x, y: y, w: w, h: h)

proc Rect2*(other: Rect2Ref): Rect2Ref =
  Rect2(other.x, other.y, other.w, other.h)

proc Rect2*(a, b: Vector2Ref): Rect2Ref =
  Rect2(a.x, a.y, b.x, b.y)


proc contains*(a: Rect2Ref, x, y: float): bool =
  a.x <= x and a.x+a.w >= x and a.y <= y and a.y+a.h >= y

proc contains*(a: Rect2Ref, b: Vector2Ref): bool =
  a.contains(b.x, b.y)


proc `$`*(a: Rect2Ref): string =
  "Rect2(x: " & $a.x & ", y: " & $a.y & ", w: " & $a.w & ", h: " & $a.h & ")"
