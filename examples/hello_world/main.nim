import toshiko


Window("Hello world")

var
  main = Scene("Main")

  label = Label("HelloWorld")

main.addChild(label)


label.setText("Hello, world!")
label.setTextAlign(0.5, 0.5, 0.5, 0.5)
label.setSizeAnchor(1, 1)

addScene(main)
setMainScene("Main")
showWindow()
