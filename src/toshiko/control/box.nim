# author: Ethosa
import
  ../core,
  ../nodes/node,
  control,
  strutils


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

  var anch: Vector2Ref
  if not self.size_anchor.isNil():
    anch = Vector2(self.size_anchor)

  self.resize(self.rect_size.x, self.rect_size.y)
  self.size_anchor = anch

method draw*(self: BoxRef, w, h: float) =
  ## This method uses for redraw Box object.
  procCall self.ControlRef.draw(w, h)

  for child in self.children:
    if child.nodetype == NODETYPE_CONTROL:
      var c = child.ControlRef
      c.rect_position.x = self.rect_size.x*self.child_anchor.x1 - c.rect_size.x*self.child_anchor.x2
      c.rect_position.y = self.rect_size.y*self.child_anchor.y1 - c.rect_size.y*self.child_anchor.y2

method setChildAnchor*(self: BoxRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes child anchor.
  self.child_anchor = Anchor(x1, y1, x2, y2)

method setChildAnchor*(self: BoxRef, anchor: AnchorRef) {.base.} =
  ## Changes child anchor.
  self.child_anchor = anchor

method setStyle*(self: BoxRef, s: StyleSheetRef) =
  procCall self.ControlRef.setStyle(s)
  for i in s.dict:
    case i.key
    of "child-anchor":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        let tmp2 = parseFloat(tmp[0])
        self.setChildAnchor(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setChildAnchor(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    else:
      discard
