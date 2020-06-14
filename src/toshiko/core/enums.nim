# author: Ethosa

type
  NodeKind* {.pure.} = enum
    # default
    NODE_NODE,
    SCENE_NODE,
    CANVAS_NODE
  NodeType* {.pure.} = enum
    NODETYPE_DEFAULT
  PauseMode* {.pure.} = enum
    PAUSE_MODE_PAUSE,
    PAUSE_MODE_RUN,
    PAUSE_MODE_INHERIT
