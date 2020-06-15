# author: Ethosa
type
  AnchorRef* = ref object
    x1*, y1*, x2*, y2*: float


proc Anchor*(x1, y1, x2, y2: float): AnchorRef =
  AnchorRef(x1: x1, y1: y1, x2: x2, y2: y2)

proc Anchor*(a: AnchorRef): AnchorRef =
  Anchor(a.x1, a.y1, a.x2, a.y2)


proc `$`*(a: AnchorRef): string =
  "Anchor(x1: " & $a.x1 & ", y1: " & $a.y1 & ", x2: " & $a.x2 & ", y2: " & $a.y2 & ")"
