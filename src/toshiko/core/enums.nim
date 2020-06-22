# author: Ethosa

type
  NodeKind* {.pure.} = enum
    # default
    NODE_NODE,
    SCENE_NODE,
    CANVAS_NODE,
    # Control nodes
    CONTROL_NODE,
    COLOR_RECT_NODE,
    TEXTURE_RECT_NODE,
    LABEL_NODE,
    BOX_NODE,
    HBOX_NODE,
    VBOX_NODE,
    BUTTON_NODE,
    GRIDBOX_NODE
  NodeType* {.pure.} = enum
    NODETYPE_DEFAULT,
    NODETYPE_CONTROL
  PauseMode* {.pure.} = enum
    PAUSE_MODE_PAUSE,
    PAUSE_MODE_RUN,
    PAUSE_MODE_INHERIT
  MouseMode* {.pure.} = enum
    MOUSEMODE_HANDLE = 1,
    MOUSEMODE_IGNORE = 2
  TextureMode* {.pure.} = enum
    TEXTUREMODE_FILL_XY,
    TEXTUREMODE_CROP,
    TEXTUREMODE_KEEP_ASPECT_RATIO
