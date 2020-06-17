# author: Ethosa
import
  ../thirdparty/sdl2/ttf,
  os


const
  user_dir* = getHomeDir()
  toshiko_dir* = user_dir / "Toshiko"
  save_dir* = "Toshiko" / "saves"

discard existsOrCreateDir(toshiko_dir)
discard existsOrCreateDir(user_dir / save_dir)

var standard_font*: FontPtr = nil

proc setStandardFont*(path: cstring, size: cint) =
  if not standard_font.isNil():
    standard_font.close()
  standard_font = openFont(path, size)
