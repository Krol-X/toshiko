# author: Ethosa
import
  ../core,
  ../nodes/node,
  control,
  box,
  strutils


type
  GridBoxObj* = object of BoxObj
    row*: int
    separator*: float
    cell_size*: Vector2Ref
  GridBoxRef* = ref GridBoxObj


proc GridBox*(name: string = "GridBox"): GridBoxRef =
  ## Creates a new GridBox object.
  nodepattern(GridBoxRef)
  controlpattern()
  result.child_anchor = Anchor(0, 0, 0, 0)
  result.cell_size = Vector2(40, 40)
  result.separator = 2f
  result.row = 3
  result.kind = GRIDBOX_NODE


method getChildsSize*(self: GridBoxRef): Vector2Ref =
  ## Calculates all childs size.
  var
    row = 0
    x = 0f
  result = Vector2()
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      inc row
      if row >= self.row or result.y == 0f:
        result.y += self.cell_size.y + self.separator
        if result.x < x:
          result.x = x
        row = 0
        x = 0
      x += self.cell_size.x + self.separator
  if result.x > 0:
    result.x -= self.separator
    result.y -= self.separator

method draw*(self: GridBoxRef, w, h: float) =
  ## This method uses for redraw Box object.
  procCall self.ControlRef.draw(w, h)

  let size = self.getChildsSize()
  var
    x = self.rect_size.x*self.child_anchor.x1 - size.x*self.child_anchor.x2
    y = self.rect_size.y*self.child_anchor.y1 - size.y*self.child_anchor.y2
    row = 0

  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      var c = child.ControlRef
      c.rect_position.x = x
      c.rect_position.y = y

      x += self.cell_size.x + self.separator
      inc row
      if row >= self.row:
        x = self.rect_size.x*self.child_anchor.x1 - size.x*self.child_anchor.x2
        y += self.cell_size.y + self.separator
        row = 0

method setCellSize*(self: GridBoxRef, size: Vector2Ref) {.base.} =
  ## Changes cell size.
  self.cell_size = size

method setRow*(self: GridBoxRef, row: int) {.base.} =
  ## Changes row count.
  self.row = row

method setStyle*(self: GridBoxRef, s: StyleSheetRef) =
  procCall self.ControlRef.setStyle(s)
  for i in s.dict:
    case i.key
    # separator: 2.0
    of "separator":
      self.separator = parseFloat(i.value)
    # cell-size: 40
    # cell-size: 64 40
    of "cell-size":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        self.cell_size = Vector2(parseFloat(tmp[0]))
      elif tmp.len() == 2:
        self.cell_size = Vector2(parseFloat(tmp[0]), parseFloat(tmp[1]))
    else:
      discard
