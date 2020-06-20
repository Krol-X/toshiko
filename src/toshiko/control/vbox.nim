# author: Ethosa
import
  ../core,
  ../nodes/node,
  control,
  box


type
  VBoxObj* = object of BoxObj
    separator*: float
  VBoxRef* = ref VBoxObj


proc VBox*(name: string = "VBox"): VBoxRef =
  ## Creates a new VBox object.
  nodepattern(VBoxRef)
  controlpattern()
  result.child_anchor = Anchor(0, 0, 0, 0)
  result.separator = 2f
  result.kind = VBOX_NODE


method getChildsSize*(self: VBoxRef): Vector2Ref =
  ## Calculates all childs size.
  result = Vector2()
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      if child.ControlRef.rect_size.x > result.x:
        result.x = child.ControlRef.rect_size.x
      result.y += child.ControlRef.rect_size.y + self.separator
  if result.y > 0:
    result.y -= self.separator

method draw*(self: VBoxRef, w, h: float) =
  ## This method uses for redraw Box object.
  procCall self.ControlRef.draw(w, h)

  var y = self.rect_size.y*self.child_anchor.y1 - self.getChildsSize().y*self.child_anchor.y2
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      var c = child.ControlRef
      c.rect_position.x = self.rect_size.x*self.child_anchor.x1 - c.rect_size.x*self.child_anchor.x2
      c.rect_position.y = y
      y += c.rect_size.y + self.separator
