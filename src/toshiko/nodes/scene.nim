# author: Ethosa
import
  ../core,
  node,
  ../control/control


type
  SceneObj* {.final.} = object of ControlObj
    paused: bool
  SceneRef* = ref SceneObj


proc Scene*(name: string = "Scene"): SceneRef =
  ## Creates a new scene.
  nodepattern(SceneRef)
  controlpattern()
  result.kind = SCENE_NODE
  result.paused = false


method draw*(self: SceneRef, w, h: float) =
  {.warning[LockLevel]: off.}
  for child in self.getAllChilds():
    if self.paused and child.getPauseMode() == PAUSE_MODE_PAUSE:
      continue
    child.on_process(child)
    child.draw(w, h)

method draw*(self: SceneRef, w, h: float, paused: bool) {.base.} =
  {.warning[LockLevel]: off.}
  self.paused = paused
  for child in self.getAllChilds():
    if self.paused and child.getPauseMode() == PAUSE_MODE_PAUSE:
      continue
    child.on_process(child)
    child.draw(w, h)

method enter*(self: SceneRef) {.base.} =
  for child in self.getAllChilds():
    child.on_enter(child)

method exit*(self: SceneRef) {.base.} =
  for child in self.getAllChilds():
    child.on_exit(child)

method handle*(self: SceneRef, event: InputEvent, mouse_on: var NodeRef) =
  {.warning[LockLevel]: off.}
  for child in self.getAllChilds():
    if self.paused and child.getPauseMode() == PAUSE_MODE_PAUSE:
      continue
    child.handle(event, mouse_on)

method instance*(self: SceneRef): SceneRef {.base.} =
  ## Special alias for deepCopy proc.
  self.deepCopy()

method reAnchorScene*(self: SceneRef, w, h: float, paused: bool) {.base.} =
  self.rect_size = Vector2(w, h)
  for child in self.getAllChilds():
    if self.paused and child.getPauseMode() == PAUSE_MODE_PAUSE:
      continue
    if child.nodetype == NODETYPE_CONTROL:
      child.ControlRef.calcAnchor()
