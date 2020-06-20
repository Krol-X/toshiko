# author: Ethosa
import
  ../core,
  ../nodes/node,
  control,
  box,
  strutils


type
  HBoxObj* = object of BoxObj
    separator*: float
  HBoxRef* = ref HBoxObj


proc HBox*(name: string = "HBox"): HBoxRef =
  ## Creates a new HBox object.
  nodepattern(HBoxRef)
  controlpattern()
  result.child_anchor = Anchor(0, 0, 0, 0)
  result.separator = 2f
  result.kind = VBOX_NODE


method getChildsSize*(self: HBoxRef): Vector2Ref =
  ## Calculates all childs size.
  result = Vector2()
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      if child.ControlRef.rect_size.y > result.y:
        result.y = child.ControlRef.rect_size.y
      result.x += child.ControlRef.rect_size.x + self.separator
  if result.x > 0:
    result.x -= self.separator

method draw*(self: HBoxRef, w, h: float) =
  ## This method uses for redraw Box object.
  procCall self.ControlRef.draw(w, h)

  var x = self.rect_size.x*self.child_anchor.x1 - self.getChildsSize().x*self.child_anchor.x2
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      var c = child.ControlRef
      c.rect_position.x = x
      c.rect_position.y = self.rect_size.y*self.child_anchor.y1 - c.rect_size.y*self.child_anchor.y2
      x += c.rect_size.x + self.separator

method setStyle*(self: HBoxRef, s: StyleSheetRef) =
  procCall self.ControlRef.setStyle(s)
  for i in s.dict:
    case i.key
    of "separator":
      self.separator = parseFloat(i.value)
    else:
      discard
