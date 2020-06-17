# author: Ethosa
import
  ../core,
  ../nodes/node,
  control


type
  BoxObj* = object of ControlObj
    child_anchor*: AnchorRef
  BoxRef* = ref BoxObj


proc Box*(name: string = "Box"): BoxRef =
  ## Creates a new Box object.
  nodepattern(BoxRef)
  controlpattern()
  result.child_anchor = Anchor(0, 0, 0, 0)
  result.kind = BOX_NODE


method getChildsSize*(self: BoxRef): Vector2Ref {.base.} =
  ## Calculates all childs size.
  result = Vector2()
  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      if child.ControlRef.rect_size.x > result.x:
        result.x = child.ControlRef.rect_size.x
      if child.ControlRef.rect_size.y > result.y:
        result.y = child.ControlRef.rect_size.y

method addChild*(self: BoxRef, other: NodeRef) =
  ## Adds a new child and recalculate rect size.
  procCall self.NodeRef.addChild(other)
  self.rect_min_size = self.getChildsSize()

  var anch: Vector2Ref = nil
  if not self.size_anchor.isNil():
    anch = Vector2(self.size_anchor)

  self.resize(self.rect_size.x, self.rect_size.y)
  self.size_anchor = anch

method draw*(self: BoxRef, w, h: float) =
  ## This method uses for redraw Box object.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.rect_global_position.x
    y = h/2 - self.rect_global_position.y

  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      var c = child.ControlRef
      c.rect_position.x = self.rect_size.x*self.child_anchor.x1 - c.rect_size.x*self.child_anchor.x2
      c.rect_position.y = self.rect_size.y*self.child_anchor.y1 - c.rect_size.y*self.child_anchor.y2

method setChildAnchor*(self: BoxRef, anchor: AnchorRef) {.base.} =
  self.child_anchor = anchor
