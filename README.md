<div align="center">
  <h1>Toshiko</h1>
  The game engine writing on Nim.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/toshiko)](https://github.com/Ethosa/toshiko/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/toshiko.svg)](https://wakatime.com/badge/github/Ethosa/toshiko)
[![Linux test](https://github.com/Ethosa/toshiko/workflows/tests_linux/badge.svg?branch=master)](https://github.com/Ethosa/toshiko/actions)
[![Github pages](https://github.com/Ethosa/toshiko/workflows/gh-pages/badge.svg)](https://github.com/Ethosa/toshiko/actions)

Latest version - 0.0.1  
Stable version - ?.?.?

</div>


## Install
1. Install this repo
   -  `nimble install https://github.com/Ethosa/toshiko.git`
2. Install dependencies
   -  Linux (tested on Ubuntu and Mint):
      - `sudo apt install -y freeglut3 freeglut3-dev`
      - `sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev`
   -  Windows / MacOS:
      -  [SDL2](https://www.libsdl.org/download-2.0.php)
      -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
      -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
      -  [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf/)
      -  [freeGLUT](http://freeglut.sourceforge.net/)
      -  Put Runtime binaries in the `.nimble/bin/` folder


## Features
- Godot-like node system.
- CSS-like stylesheets support.
- Little dynamic type.
- Build nodes with YML-like syntax.
- Convert the JSON/XML files to the Scenes.


## Simple usage
```nim
import toshiko

Window(title="Test window", w=720, h=480)
setStandardFont("assets/unifont.ttf", 16)

var
  scene = Scene("Main")
  label = Label()

label.setText("Hello, world!")
scene.addChild(label)

addMainScene(scene)
showWindow()
```


## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html) for export to the other OS.

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program.


## F.A.Q
*Q*: Where can I see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/toshiko/blob/master/tests) folder

*Q*: Where can I read the docs?   
*A*: You can read docs [here](https://ethosa.github.io/toshiko/toshiko.html)


<div align="center">Copyright Ethosa 2020</div>
