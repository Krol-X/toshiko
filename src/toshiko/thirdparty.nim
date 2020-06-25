when defined(static_sdl2) and defined(windows):
  ## Enables static linking, when defined `static_sdl2` or `sdlstatic` on Windows.
  ## compile with `-d:static_sdl2 --dynlibOverride:libSDL2`.
  {.passL: "-static -lmingw32 -lSDL2main -lSDL2 -mwindows -Wl,--no-undefined -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lshell32 -lsetupapi -lversion -luuid".}

import
  thirdparty/opengl,
  thirdparty/sdl2

export
  opengl, sdl2
