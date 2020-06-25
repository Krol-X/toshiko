<div align="center">
  <h1>Toshiko</h1>
  The game engine writing in Nim.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/toshiko)](https://github.com/Ethosa/toshiko/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/toshiko.svg)](https://wakatime.com/badge/github/Ethosa/toshiko)  
[![Ubuntu tests](https://github.com/Ethosa/toshiko/workflows/Ubuntu%20tests/badge.svg)](https://github.com/Ethosa/toshiko/blob/master/tests)
[![Github pages](https://github.com/Ethosa/toshiko/workflows/gh-pages/badge.svg)](https://ethosa.github.io/toshiko/toshiko.html)
[![Examples](https://github.com/Ethosa/toshiko/workflows/examples/badge.svg)](https://github.com/Ethosa/toshiko/blob/master/examples)

Latest version - 0.0.2  
Stable version - 0.0.1

</div>


## Install
1. Install this repo
   -  last stable version `nimble install https://github.com/Ethosa/toshiko.git`
   -  specific version `nimble install https://github.com/Ethosa/toshiko.git@1.2.3`
2. Install dependencies
   -  Linux (tested on Ubuntu, Debian and Mint):
      - `sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev`
   -  Windows / MacOS:
      -  [SDL2](https://www.libsdl.org/download-2.0.php)
      -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
      -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
      -  [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf/)
      -  Put Runtime binaries in the `.nimble/bin/` folder


## Features
- Godot-like node system.
- CSS-like stylesheets support.
- Little dynamic type.
- Build nodes with YML-like syntax.
- Convert the JSON/XML files to the Scenes.
- Global settings in the root of the project (`global_settings.toshiko`).


## Simple usage
```nim
import toshiko

Window(title="Test window", w=720, h=480)
setStandardFont("assets/unifont.ttf", 16)  # or indicate this in `global_settings.toshiko`

var
  scene = Scene("Main")
  label = Label()

label.setText("Hello, world!")
scene.addChild(label)

addMainScene(scene)
showWindow()
```

## Now availale
See [`Nodes list`](https://github.com/Ethosa/toshiko/blob/master/NODES_LIST.md) file.


## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html) for export to the other OS.  
[Static linking SDL2](https://github.com/nim-lang/sdl2#static-linking-sdl2) (or compile with `-d:static_sdl2 --dynlibOverride:libSDL2`)

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program or use static linking.


## F.A.Q
*Q*: Where can I see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/toshiko/blob/master/tests) or [`examples`](https://github.com/Ethosa/toshiko/blob/master/examples) folder

*Q*: Where can I read the docs?   
*A*: You can read docs [here](https://ethosa.github.io/toshiko/toshiko.html)

*Q*: Can I create my own Node?  
*A*: Yeap, you can :eyes:, follow this [tutorial](https://github.com/Ethosa/toshiko/wiki/Own-Nodes) ^^


<div align="center">Copyright Ethosa 2020</div>
