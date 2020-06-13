# author: Ethosa
import
  thirdparty/opengl,
  thirdparty/opengl/glut,

  nodes/node,
  nodes/scene,

  os


var
  cmdLine {.importc: "cmdLine".}: array[0..255, cstring]
  cmdCount {.importc: "cmdCount".}: cint



var
  width, height: cint
  main_scene*: SceneRef = nil
  current_scene*: SceneRef = nil
  scenes*: seq[SceneRef] = @[]
  paused*: bool = false


# --- Callbacks --- #
var
  mouse_on: NodeRef = nil
  window_created: bool = false

proc display {.cdecl.} =
  ## Displays window.
  glClearColor(1, 1, 1, 1)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  # Draw current scene.
  current_scene.draw(width.GLfloat, height.GLfloat, paused)
  # press_state = -1
  mouse_on = nil

  # Update window.
  glFlush()
  glutSwapBuffers()
  os.sleep(17)


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
  main_scene = scene

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
      main_scene = scene
      break

proc setTitle*(title: cstring) =
  ## Changes window title.
  if window_created:
    glutSetWindowTitle(title)

proc Window*(title: cstring, w: cint = 640, h: cint = 360) {.cdecl.} =
  ## Creates a new window pointer
  ##
  ## Arguments:
  ## - `title` - window title.
  # Set up window.
  once:
    when not defined(android) and not defined(ios):
      loadExtensions()  # Load OpenGL extensions.

    glutInit(addr cmdCount, addr cmdLine) # Initializ glut lib.
    glutInitDisplayMode(GLUT_DOUBLE)
  glutInitWindowSize(w, h)
  glutInitWindowPosition(100, 100)
  discard glutCreateWindow(title)

  # Set up OpenGL
  glClearColor(1, 1, 1, 1)
  glShadeModel(GL_FLAT)
  glClear(GL_COLOR_BUFFER_BIT)

  reshape(w, h)
  window_created = true


proc showWindow* =
  ## Start main window loop.
  glutDisplayFunc(display)
  glutIdleFunc(display)
  changeScene(main_scene.name)
  glutMainLoop()
  current_scene.exit()
