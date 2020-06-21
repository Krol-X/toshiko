# author: Ethosa
import
  vector2,
  mathcore


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

proc contains*(a, b: Rect2Ref): bool =
  ## Returns true, when `b` inside `a`.
  a.contains(b.x, b.y) and a.contains(b.x+b.w, b.y) and a.contains(b.x, b.y+b.h) and a.contains(b.x+b.w, b.y+b.h)

proc intersects*(a, b: Rect2Ref): bool =
  ## Returns true, when `b` and `a` is intersects.
  (
    a.contains(b.x, b.y) or a.contains(b.x+b.w, b.y) or a.contains(b.x, b.y+b.h) or a.contains(b.x+b.w, b.y+b.h) or
    b.contains(a.x, a.y) or b.contains(a.x+a.w, a.y) or b.contains(a.x, a.y+a.h) or b.contains(a.x+a.w, a.y+a.h)
  )

proc intersectsCircle*(a: Rect2Ref, cx, cy, r: float): bool =
  ## Returns true, when `a` intersects with circle.
  ##
  ## Arguments:
  ## - `cx` is a circle center at X axis.
  ## - `cy` is a circle center at Y axis.
  ## - `r` is a circle radius.
  let
    dx = normalize(cx, a.x, a.x+a.w) - cx
    dy = normalize(cy, a.y, a.y+a.h) - cy
  dx*dx + dy*dy <= r*r


proc `$`*(a: Rect2Ref): string =
  ## Converts Rect2 to its string representation.
  "Rect2(x: " & $a.x & ", y: " & $a.y & ", w: " & $a.w & ", h: " & $a.h & ")"
