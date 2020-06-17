# author: Ethosa
import
  ../thirdparty/sdl2/ttf,
  ../core,
  ../nodes/node,
  control,
  strutils


type
  LabelObj* = object of ControlObj
    text_align*: AnchorRef
    text*: StyleText
  LabelRef* = ref LabelObj


proc Label*(name: string = "Label", text: string = ""): LabelRef =
  nodepattern(LabelRef)
  controlpattern()
  result.text = stext(text)
  result.text_align = Anchor(0, 0, 0, 0)
  result.kind = LABEL_NODE


method draw*(self: LabelRef, w, h: float) =
  ## This method uses for redraw Label object.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.rect_global_position.x
    y = h/2 - self.rect_global_position.y

  self.text.render(Vector2(x, y), self.rect_size, self.text_align)

method getText*(self: LabelRef): string {.base.} =
  $self.text

method setText*(self: LabelRef, text: string, save_properties: bool = false) {.base.} =
  ## Changes text.
  ##
  ## Arguments:
  ## - `text` is a new Label text.
  ## - `save_properties` - saves old text properties, if `true`.
  var st = stext(text)
  st.font = self.text.font

  if save_properties:
    for i in 0..<st.chars.len():
      if i < self.text.len():
        st.chars[i].color = self.text.chars[i].color
        st.chars[i].underline = self.text.chars[i].underline
  self.text = st
  self.rect_size = self.text.getTextSize()

method setTextAlign*(self: LabelRef, x1, y1, x2, y2: float) {.base.} =
  self.text_align = Anchor(x1, y1, x2, y2)

method setTextAlign*(self: LabelRef, align: AnchorRef) {.base.} =
  self.text_align = align

method setTextColor*(self: LabelRef, color: ColorRef) {.base.} =
  self.text.setColor(color)

method setTextFont*(self: LabelRef, font: FontPtr) {.base.} =
  self.text.font = font

method setStyle*(self: LabelRef, s: StyleSheetRef) =
  procCall self.ControlRef.setStyle(s)

  for i in s.dict:
    case i.key
    # text-align: 0.5
    # text-align: 0.5 0 0.5 0
    of "text-align":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        if tmp[0] == "center":
          self.setTextAlign(0.5, 0.5, 0.5, 0.5)
        elif tmp[0] == "left":
          self.setTextAlign(0, 0.5, 0, 0.5)
        elif tmp[0] == "right":
          self.setTextAlign(1, 0.5, 1, 0.5)
        elif tmp[0] == "top":
          self.setTextAlign(0.5, 0, 0.5, 0)
        elif tmp[0] == "bottom":
          self.setTextAlign(0.5, 1, 0.5, 1)
        else:
          let tmp2 = parseFloat(tmp[0])
          self.setTextAlign(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setTextAlign(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    # color: #f6f
    of "color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setTextColor(clr)
    else:
      discard
