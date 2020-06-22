# author: Ethosa
import
  thirdparty/opengl,
  thirdparty/sdl2,
  thirdparty/sdl2/image,

  core/color,
  core/input,

  nodes/node,
  nodes/scene,

  environment,

  os


discard sdl2.init(INIT_EVERYTHING)

discard glSetAttribute(SDL_GL_DOUBLEBUFFER, 1)
discard glSetAttribute(SDL_GL_RED_SIZE, 5)
discard glSetAttribute(SDL_GL_GREEN_SIZE, 6)
discard glSetAttribute(SDL_GL_BLUE_SIZE, 5)


var
  env* = EnvironmentRef(delay: 17, background_color: Color("#333"))
  width, height: cint
  main_scenesdl*: SceneRef = nil
  windowptr: WindowPtr
  glcontext: GlContextPtr
  current_scene*: SceneRef = nil
  scenes*: seq[SceneRef] = @[]
  paused*: bool = false
  running*: bool = true
  event = sdl2.defaultEvent


# --- Callbacks --- #
var
  mouse_on: NodeRef = nil
  window_created: bool = false

proc display {.cdecl.} =
  ## Displays window.
  glClearColor(env.background_color.r, env.background_color.g, env.background_color.b, env.background_color.a)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  # Draw current scene.
  current_scene.draw(width.GLfloat, height.GLfloat, paused)
  press_state = -1
  mouse_on = nil

  # Update window.
  glFlush()
  windowptr.glSwapWindow()
  os.sleep(env.delay)


proc reshape(w, h: cint) {.cdecl.} =
  ## This called when window resized.
  if w > 0 and h > 0:
    glViewport(0, 0, w, h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-w.GLdouble/2, w.GLdouble/2, -h.GLdouble/2, h.GLdouble/2, -w.GLdouble, w.GLdouble)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    width = w
    height = h

    if current_scene != nil:
      current_scene.reAnchorScene(w.GLfloat, h.GLfloat, paused)

template check(event, condition, conditionelif: untyped): untyped =
  if last_event is `event` and `condition`:
    press_state = 2
  elif `conditionelif`:
    press_state = 1
  else:
    press_state = 0

proc mouse(button, x, y: cint, pressed: bool) {.cdecl.} =
  ## Handle mouse input.
  check(InputEventMouseButton, last_event.pressed and pressed, pressed)
  last_event.button_index = button
  last_event.x = x.float
  last_event.y = y.float
  last_event.kind = MOUSE
  mouse_pressed = pressed
  last_event.pressed = pressed

  current_scene.handle(last_event, mouse_on)

proc wheel(x, y: cint) {.cdecl.} =
  ## Handle mouse wheel input.
  check(InputEventMouseWheel, false, false)
  last_event.kind = WHEEL
  last_event.xrel = x.float
  last_event.yrel = y.float

  current_scene.handle(last_event, mouse_on)

proc keyboardpress(c: cint) {.cdecl.} =
  ## Called when press any key on keyboard.
  if c < 0:
    return
  let key = $c
  check(InputEventKeyboard, last_event.pressed, true)
  last_event.key = key
  last_event.key_int = c
  if key notin pressed_keys:
    pressed_keys.add(key)
    pressed_keys_ints.add(c)
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = true

  current_scene.handle(last_event, mouse_on)

proc keyboardup(c: cint) {.cdecl.} =
  ## Called when any key no more pressed.
  if c < 0:
    return
  let key = $c
  check(InputEventKeyboard, false, false)
  last_event.key = key
  last_event.key_int = c
  last_event.kind = KEYBOARD
  last_key_state = key_state
  key_state = false
  var i = 0
  for k in pressed_keys:
    if k == key:
      pressed_keys.delete(i)
      pressed_keys_ints.delete(i)
      break
    inc i

  current_scene.handle(last_event, mouse_on)

proc motion(x, y: cint) {.cdecl.} =
  ## Called on any mouse motion.
  last_event.kind = MOTION
  last_event.xrel = last_event.x - x.float
  last_event.yrel = last_event.y - y.float
  last_event.x = x.float
  last_event.y = y.float

  current_scene.handle(last_event, mouse_on)


# ---- Public ---- #
proc addScene*(scene: SceneRef) =
  ## Adds a new scenes in app.
  ##
  ## Arguments:
  ## - `scene` - pointer to the Scene object.
  if scene notin scenes:
    scenes.add(scene)

proc addMainScene*(scene: SceneRef) =
  ## Adds a new scene in the app and set it mark it as main scene.
  ##
  ## Arguents:
  ## - `scene` - pointer to the Scene object.
  if scene notin scenes:
    scenes.add(scene)
  main_scenesdl = scene

proc changeScene*(name: string): bool {.discardable.} =
  ## Changes current scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  result = false
  for scene in scenes:
    if scene.name == name:
      if current_scene != nil:
        current_scene.exit()
      current_scene = nil
      current_scene = scene
      current_scene.enter()
      current_scene.reAnchorScene(width.GLfloat, height.GLfloat, paused)
      result = true
      break

proc setMainScene*(name: string) =
  ## Set up main scene.
  ##
  ## Arguments:
  ## - `name` - name of the added scene.
  for scene in scenes:
    if scene.name == name:
      main_scenesdl = scene
      break

proc setTitle*(title: cstring) =
  ## Changes window title.
  if window_created:
    windowptr.setTitle(title)

proc setIcon*(icon_path: cstring) =
  ## Changes window title.
  if window_created:
    windowptr.setIcon(image.load(icon_path))

proc Window*(title: cstring, w: cint = 640, h: cint = 360) {.cdecl.} =
  ## Creates a new window pointer
  ##
  ## Arguments:
  ## - `title` - window title.
  # Set up window.
  once:
    when not defined(android) and not defined(ios):
      loadExtensions()  # Load OpenGL extensions.
      discard captureMouse(True32)
  windowptr = createWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, w, h,
    SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL or SDL_WINDOW_RESIZABLE or
    SDL_WINDOW_ALLOW_HIGHDPI or SDL_WINDOW_FOREIGN or SDL_WINDOW_INPUT_FOCUS or SDL_WINDOW_MOUSE_FOCUS)
  glcontext = windowptr.glCreateContext()

  # Set up OpenGL
  glClearColor(env.background_color.r, env.background_color.g, env.background_color.b, env.background_color.a)
  glShadeModel(GL_FLAT)
  glClear(GL_COLOR_BUFFER_BIT)

  reshape(w, h)
  window_created = true


proc showWindow* =
  changeScene(main_scenesdl.name)

  while running:
    while sdl2.pollEvent(event):
      case event.kind
      of QuitEvent:
        running = false
      of WindowEvent:
        let e = evWindow(event)
        case e.event
        of WindowEvent_Resized, WindowEvent_SizeChanged, WindowEvent_Minimized, WindowEvent_Maximized, WindowEvent_Restored:
          windowptr.getSize(width, height)
          reshape(width, height)
        else:
          discard
      of KeyDown:
        let e = evKeyboard(event)
        keyboardpress(e.keysym.sym)
      of KeyUp:
        let e = evKeyboard(event)
        keyboardup(e.keysym.sym)
      of MouseMotion:
        let e = evMouseMotion(event)
        motion(e.x, e.y)
      of MouseButtonDown:
        let e = evMouseButton(event)
        mouse(e.button.cint, e.x, e.y, true)
      of MouseButtonUp:
        let e = evMouseButton(event)
        mouse(e.button.cint, e.x, e.y, false)
      of MouseWheel:
        let e = evMouseWheel(event)
        wheel(e.x, e.y)
      else:
        discard
    display()

  current_scene.exit()
  sdl2.glDeleteContext(glcontext)
  sdl2.destroy(windowptr)
  sdl2.quit()
