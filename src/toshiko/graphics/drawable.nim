# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/color,
  ../core/stylesheet,
  ../core/image,
  ../core/vector2,

  math,
  strutils



type
  DrawableObj* = object
    border_width: float
    border_detail_lefttop: int
    border_detail_righttop: int
    border_detail_leftbottom: int
    border_detail_rightbottom: int
    border_radius_lefttop: float
    border_radius_righttop: float
    border_radius_leftbottom: float
    border_radius_rightbottom: float
    border_color: ColorRef
    background_color: ColorRef
    texture*: GlTextureObj
  DrawableRef* = ref DrawableObj


proc Drawable*: DrawableRef =
  DrawableRef(
    texture: GlTextureObj(), border_width: 0,
    border_detail_lefttop: 50,
    border_detail_righttop: 50,
    border_detail_leftbottom: 50,
    border_detail_rightbottom: 50,
    border_radius_lefttop: 0,
    border_radius_righttop: 0,
    border_radius_leftbottom: 0,
    border_radius_rightbottom: 0,
    border_color: Color(0, 0, 0, 0),
    background_color: Color(0, 0, 0, 0)
  )


proc norm(v: float): float =
  if v > 1f: 1f elif v < 0f: 0f else: v

template vd = discard

template recalc =
  # left top
  vertex.add(Vector2(x, y - self.border_radius_lefttop))
  for i in 0..self.border_detail_lefttop:
    let angle = TAU*(i/self.border_detail_lefttop)
    if angle >= PI and angle <= PI+PI/2:
      vertex.add(Vector2(x + self.border_radius_lefttop + self.border_radius_lefttop*cos(angle), y - self.border_radius_lefttop - self.border_radius_lefttop*sin(angle)))
  vertex.add(Vector2(x + self.border_radius_lefttop, y))

  # right top
  vertex.add(Vector2(x + width - self.border_radius_righttop, y))
  for i in 0..self.border_detail_righttop:
    let angle = TAU*(i/self.border_detail_righttop)
    if angle >= PI+PI/2 and angle <= TAU:
      vertex.add(Vector2(x + width - self.border_radius_righttop + self.border_radius_righttop*cos(angle), y - self.border_radius_righttop - self.border_radius_righttop*sin(angle)))
  vertex.add(Vector2(x + width, y - self.border_radius_righttop))

  # right bottom
  vertex.add(Vector2(x + width, y - height + self.border_radius_rightbottom))
  for i in 0..self.border_detail_rightbottom:
    let angle = TAU*(i/self.border_detail_rightbottom)
    if angle >= 0 and angle <= PI/2:
      vertex.add(Vector2(x + width - self.border_radius_rightbottom + self.border_radius_rightbottom*cos(angle), y - height + self.border_radius_rightbottom - self.border_radius_rightbottom*sin(angle)))
  vertex.add(Vector2(x + width - self.border_radius_rightbottom, y - height))

  # left bottom
  vertex.add(Vector2(x + self.border_radius_leftbottom, y - height))
  for i in 0..self.border_detail_leftbottom:
    let angle = TAU*(i/self.border_detail_leftbottom)
    if angle >= PI/2 and angle <= PI:
      vertex.add(Vector2(x + self.border_radius_leftbottom + self.border_radius_leftbottom*cos(angle), y - height + self.border_radius_leftbottom - self.border_radius_leftbottom*sin(angle)))
  vertex.add(Vector2(x, y - height + self.border_radius_leftbottom))


template draw_template(drawtype, color, function, secondfunc: untyped): untyped =
  glColor4f(self.`color`.r, self.`color`.g, self.`color`.b, self.`color`.a)
  `function`
  glBegin(`drawtype`)

  for i in vertex:
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`

template draw_texture_template(drawtype, color, function, secondfunc: untyped): untyped =
  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, self.texture.texture)
  glColor4f(self.`color`.r, self.`color`.g, self.`color`.b, self.`color`.a)
  `function`
  glBegin(`drawtype`)

  for i in vertex:
    glTexCoord2f((x + width - i.x) / width, 1f - ((-y + height - -i.y) / height))
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`
  glDisable(GL_TEXTURE_2D)


proc draw*(self: DrawableRef, x, y, width, height: float) =
  var vertex: seq[Vector2Ref] = @[]
  recalc()
  if self.texture.texture > 0:
    draw_texture_template(GL_POLYGON, background_color, vd(), vd())
  else:
    draw_template(GL_POLYGON, background_color, vd(), vd())
  if self.border_width > 0f:
    draw_template(GL_LINE_LOOP, border_color, glLineWidth(self.border_width), glLineWidth(1))


proc getColor*(self: DrawableRef): ColorRef =
  self.background_color

proc setBorderColor*(self: DrawableRef, color: ColorRef) =
  self.border_color = color

proc setBorderWidth*(self: DrawableRef, width: float) =
  self.border_width = width

proc setColor*(self: DrawableRef, color: ColorRef) =
  self.background_color = color

proc setCornerRadius*(self: DrawableRef, radius: float) =
  self.border_radius_lefttop = radius
  self.border_radius_righttop = radius
  self.border_radius_leftbottom = radius
  self.border_radius_rightbottom = radius

proc setCornerRadius*(self: DrawableRef, r1, r2, r3, r4: float) =
  self.border_radius_lefttop = r1
  self.border_radius_righttop = r2
  self.border_radius_rightbottom = r3
  self.border_radius_leftbottom = r4

proc setCornerDetail*(self: DrawableRef, detail: int) =
  self.border_detail_lefttop = detail
  self.border_detail_righttop = detail
  self.border_detail_leftbottom = detail
  self.border_detail_rightbottom = detail

proc setCornerDetail*(self: DrawableRef, d1, d2, d3, d4: int) =
  self.border_detail_lefttop = d1
  self.border_detail_righttop = d2
  self.border_detail_leftbottom = d4
  self.border_detail_rightbottom = d3

proc setTexture*(self: DrawableRef, texture: GlTextureObj) =
  self.texture = texture
  self.background_color = Color(1f, 1f, 1f, 1f)

proc setStyle*(self: DrawableRef, s: StyleSheetRef) =
  for i in s.dict:
    case i.key
    # background-color: rgb(51, 100, 255)
    of "background-color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setColor(clr)
    # border-color: rgba(55, 255, 177, 0.1)
    of "border-color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setBorderColor(clr)
    # border-radius: 5
    of "border-radius":
      self.setCornerRadius(parseFloat(i.value))
    # border-detail: 5
    of "border-detail":
      self.setCornerDetail(parseInt(i.value))
    # border-width: 5
    of "border-width":
      self.setBorderWidth(parseFloat(i.value))
    # border: 2 turquoise
    of "border":
      var tmp = i.value.rsplit(Whitespace, 1)
      self.setCornerRadius(parseFloat(tmp[0]))
      self.setBorderColor(Color(tmp[1]))
    else:
      discard
