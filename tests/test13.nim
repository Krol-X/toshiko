# --- Test 13. Use Label object --- #
import toshiko


Window("Test 13")

var
  scene = Scene()
  label = Label()
  unifont = loadFont("assets/unifont.ttf", 16)

scene.addChild(label)
label.setTextFont(unifont)
label.setText("Hello, world!")
label.resize(256, 128)
label.setStyle(style(
  {
    color: rgb(111, 174, 245),
    background-color: rgba(240, 240, 240, 0.3),
    border-radius: 8,
    text-align: center
  }
))

addMainScene(scene)
showWindow()
