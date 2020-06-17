# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image,

  ../core/vector2


discard image.init()


type
  GlTextureObj* = object
    texture*: Gluint
    size*: Vector2Ref


proc toGlTexture*(surface: SurfacePtr, x, y: var float): Gluint =
  var textureid: Gluint
  if surface.isNil():
    when defined(debug):
      echo "Could not load texture: surface is nil!"
    return 0'u32
  x = surface.w.float
  y = surface.h.float
  var mode =
    if surface.format.Amask != 0:
      GL_RGBA
    else:
      GL_RGB

  # OpenGL:
  glGenTextures(1, textureid.addr)
  glBindTexture(GL_TEXTURE_2D, textureid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(GL_TEXTURE_2D, 0, mode.GLint, surface.w,  surface.h, 0, mode, GL_UNSIGNED_BYTE, surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)

  # free memory
  surface.freeSurface()

  textureid


proc load*(file: cstring, x, y: var float): Gluint =
  ## Loads image from file and returns texture ID.
  ##
  ## Arguments:
  ## - `file` - image path.
  var surface = image.load(file)  # load image from file
  return toGlTexture(surface, x, y)


proc load*(file: cstring): GlTextureObj =
  ## Loads GL texture.
  ##
  ## Arguments:
  ## - `file` - image path.
  var
    x: float = 0f
    y: float = 0f
    textureid: Gluint
  textureid = load(file, x, y)
  GlTextureObj(texture: textureid, size: Vector2(x, y))
