import toshiko
import random
randomize()


Window("ScreenSaver", 720, 480)


var
  main = Scene("Main")

  img = load("img.png")

  sprite = TextureRect()

  direction = Vector2()
  speed = 3f

sprite.resize(256, 256)
sprite.setTexture(img)

sprite@on_process(self):
  let rect = Rect2(sprite.rect_global_position, sprite.rect_size)
  if rect.x <= 0:
    direction = sprite.rect_global_position.directionTo(Vector2(main.rect_size.x, rand(main.rect_size.y.int).float))
    sprite.texture_filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
  elif rect.x+rect.w >= main.rect_size.x:
    direction = sprite.rect_global_position.directionTo(Vector2(0, rand(main.rect_size.y.int).float))
    sprite.texture_filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
  elif rect.y <= 0:
    direction = sprite.rect_global_position.directionTo(Vector2(rand(main.rect_size.x.int).float, main.rect_size.y))
    sprite.texture_filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)
  elif rect.y+rect.h >= main.rect_size.y:
    direction = sprite.rect_global_position.directionTo(Vector2(rand(main.rect_size.x.int).float, 0))
    sprite.texture_filter = Color(rand(1f) + 0.5, rand(1f) + 0.5, rand(1f) + 0.5)

  sprite.move(direction*speed)


main.addChild(sprite)
addScene(main)
setMainScene("Main")
showWindow()
