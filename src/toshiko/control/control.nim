# author: Ethosa
import
  ../thirdparty/opengl,

  ../graphics,
  ../core,
  ../nodes/node,
  strutils


type
  ControlHandler* = proc(self: ControlRef, x, y: float): void
  ControlObj* = object of NodeObj
    hovered*: bool
    focused*: bool
    pressed*: bool
    rect_position*: Vector2Ref
    rect_global_position*: Vector2Ref
    rect_size*: Vector2Ref
    rect_min_size*: Vector2Ref
    size_anchor*: Vector2Ref
    position_anchor*: AnchorRef
    background*: DrawableRef

    on_hover*: ControlHandler
    on_out*: ControlHandler
    on_click*: ControlHandler
    on_press*: ControlHandler
    on_focus*: ControlHandler
    on_unfocus*: ControlHandler
    on_release*: ControlHandler
  ControlRef* = ref ControlObj

var standard_control_handler = proc(self: ControlRef, x, y: float) = discard

template controlpattern* =
  result.hovered = false
  result.focused = false
  result.pressed = false
  result.rect_position = Vector2()
  result.rect_global_position = Vector2()
  result.rect_size = Vector2()
  result.rect_min_size = Vector2()
  result.background = Drawable()

  result.on_hover = standard_control_handler
  result.on_out = standard_control_handler
  result.on_click = standard_control_handler
  result.on_press = standard_control_handler
  result.on_focus = standard_control_handler
  result.on_unfocus = standard_control_handler
  result.on_release = standard_control_handler

  result.nodetype = NODETYPE_CONTROL

proc Control*(name: string = "Control"): ControlRef =
  ## Creates a new Control object.
  nodepattern(ControlRef)
  controlpattern()
  result.kind = CONTROL_NODE


method calcRectGlobalPosition*(self: ControlRef) {.base.} =
  self.rect_global_position = self.rect_position
  var current = self.NodeRef
  while current.parent != nil:
    current = current.parent
    if current.nodetype == NODETYPE_CONTROL:
      self.rect_global_position += current.ControlRef.rect_position

method calcAnchor*(self: ControlRef) {.base.} =
  if not self.parent.isNil() and self.parent.nodetype == NODETYPE_CONTROL:
    if not self.size_anchor.isNil():
      if self.size_anchor.x > 0:
        self.rect_size.x = self.parent.ControlRef.rect_size.x * self.size_anchor.x
      if self.size_anchor.y > 0:
        self.rect_size.y = self.parent.ControlRef.rect_size.y * self.size_anchor.y
    if not self.position_anchor.isNil():
      self.rect_position.x = self.parent.ControlRef.rect_size.x*self.position_anchor.x1 - self.rect_size.x*self.position_anchor.x2
      self.rect_position.y = self.parent.ControlRef.rect_size.y*self.position_anchor.y1 - self.rect_size.y*self.position_anchor.y2

method draw*(self: ControlRef, w, h: float) =
  {.warning[LockLevel]: off.}
  self.calcRectGlobalPosition()
  let
    x = -w/2 + self.rect_global_position.x
    y = h/2 - self.rect_global_position.y

  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method getBackground*(self: ControlRef): DrawableRef {.base.} =
  self.background

method getGlobalMousePosition*(self: ControlRef): Vector2Ref {.base.} =
  Vector2(last_event.x, last_event.y)

method handle(self: ControlRef, event: InputEvent, mouse_on: var NodeRef) =
  if mouse_on.isNil():
    let hasmouse = Rect2(self.rect_global_position, self.rect_size).contains(event.x, event.y)
    if hasmouse:
      mouse_on = self
      if not self.hovered:
        self.on_hover(self, event.x, event.y)
        self.hovered = true
      if event.kind == MOUSE:
        if event.pressed:
          if not self.pressed:
            self.on_click(self, event.x, event.y)
            self.pressed = true
          if not self.focused:
            self.on_focus(self, event.x, event.y)
            self.focused = true
        else:
          self.pressed = false
          self.on_release(self, event.x, event.y)
  if mouse_on != self:
    if self.hovered:
      self.on_out(self, event.x, event.y)
      self.hovered = false
      if not event.pressed:
        self.pressed = false
        self.on_release(self, event.x, event.y)
      elif self.focused:
        self.on_unfocus(self, event.x, event.y)

method move*(self: ControlRef, x, y: float) {.base.} =
  self.position_anchor = nil
  self.rect_position.x += x
  self.rect_position.y += y

method resize*(self: ControlRef, w, h: float) {.base.} =
  if w > self.rect_min_size.x:
    self.rect_size.x = w
    self.size_anchor = nil
  if w > self.rect_min_size.y:
    self.rect_size.y = h
    self.size_anchor = nil

method setBackground*(self: ControlRef, back: DrawableRef) {.base.} =
  self.background = back

method setBackgroundColor*(self: ControlRef, color: ColorRef) {.base.} =
  self.background.setColor(color)

method setAnchor*(self: ControlRef, anchor: AnchorRef) {.base.} =
  self.position_anchor = anchor

method setSizeAnchor*(self: ControlRef, anchor: Vector2Ref) {.base.} =
  self.size_anchor = anchor

method setStyle*(self: ControlRef, s: StyleSheetRef) {.base.} =
  self.background.setStyle(s)
  for i in s.dict:
    case i.key
    # size-anchor: 1.0
    # size-anchor: 0.5 1
    of "size-anchor":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        self.setSizeAnchor(Vector2(parseFloat(tmp[0])))
      elif tmp.len() == 2:
        self.setSizeAnchor(Vector2(parseFloat(tmp[0]), parseFloat(tmp[1])))
    # position-anchor: 1
    # position-anchor: 0.5 1 0.5 1
    of "position-anchor":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        let tmp2 = parseFloat(tmp[0])
        self.setAnchor(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setAnchor(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    else:
      discard
