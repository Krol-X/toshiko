# author: Ethosa
## It provides primitive display progress.
import
  ../thirdparty/opengl,
  ../core,
  ../graphics/drawable,
  ../nodes/node,
  control


type
  ProgressBarType* {.pure.} = enum
    PROGRESS_BAR_HORIZONTAL,
    PROGRESS_BAR_VERTICAL
  ProgressBarObj* = object of ControlObj
    indeterminate*: bool
    value*, max_value*: int
    indeterminate_val*: float
    progress_color*: ColorRef
    progress_type*: ProgressBarType
  ProgressBarRef* = ref ProgressBarObj


proc ProgressBar*(name: string = "ProgressBar"): ProgressBarRef =
  ## Creates a new ProgressBar object.
  nodepattern(ProgressBarRef)
  controlpattern()
  result.value = 0
  result.max_value = 100
  result.background.setColor(Color(0.4, 0.4, 0.4))
  result.progress_color = Color(0.6, 0.6, 0.6)
  result.rect_size.x = 120
  result.rect_size.y = 20
  result.indeterminate = false
  result.indeterminate_val = 0
  result.progress_type = PROGRESS_BAR_HORIZONTAL
  result.kind = PROGRESS_BAR_NODE


method changeProgressBar*(self: ProgressBarRef, ptype: ProgressBarType) {.base.} =
  ## Changes ProgressBar type.
  ##
  ## `ptype` should be `PROGRESS_BAR_HORIZONTAL`.
  self.progress_type = ptype

method draw*(self: ProgressBarRef, w, h: float) =
  ## It uses for redraw ProgressBar.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.rect_global_position.x
    y = h/2 - self.rect_global_position.y

  # draw progress
  let progress_percent = self.value / self.max_value
  
  glColor4f(self.progress_color.r, self.progress_color.g, self.progress_color.b, self.progress_color.a)

  case self.progress_type
  of PROGRESS_BAR_HORIZONTAL:
    let progress_width = progress_percent * self.rect_size.x
    if self.indeterminate:
      if self.indeterminate_val - progress_width < self.rect_size.x:
        self.indeterminate_val += self.rect_size.x * 0.01
      else:
        self.indeterminate_val = -progress_width
      glRectf(
        normalize(x + self.indeterminate_val, x, x + self.rect_size.x), y,
        normalize(x + self.indeterminate_val + progress_width, x, x + self.rect_size.x), y - self.rect_size.y)
    else:
      glRectf(x, y, x + progress_width, y - self.rect_size.y)
  of PROGRESS_BAR_VERTICAL:
    let progress_width = progress_percent * self.rect_size.y
    if self.indeterminate:
      if self.indeterminate_val - progress_width < self.rect_size.y:
        self.indeterminate_val += self.rect_size.y * 0.01
      else:
        self.indeterminate_val = -progress_width
      glRectf(
        x, normalize(y - self.indeterminate_val, y - self.rect_size.y, y),
        x + self.rect_size.x, normalize(y - self.indeterminate_val - progress_width, y - self.rect_size.y, y))
    else:
      glRectf(x, y, x + self.rect_size.x, y - progress_width)

method enableIndeterminate*(self: ProgressBarRef, val: bool = true) {.base.} =
  ## Enables or disables ProgressBar indeterminate.
  self.indeterminate = val

method setMaxValue*(self: ProgressBarRef, val: int) {.base.} =
  ## Changes progress bar max value, if `val` > `value`
  if val > self.value:
    self.max_value = val

method setProgressColor*(self: ProgressBarRef, color: ColorRef) {.base.} =
  ## Changes progress color.
  self.progress_color = color

method setValue*(self: ProgressBarRef, val: int) {.base.} =
  ## Changes progress bar value, if 0 < `val` < `max_value`.
  if val > 0 and val < self.max_value:
    self.value = val
