# author: Ethosa
## Provides JSON to Node.
import
  json,  # parser from stdlib
  nodes,
  control,
  core


template loadnode(fn: untyped): untyped =
  if level.len() > 0:
    level[^1].addChild(`fn`())
    if value.kind == JObject:
      level.add(level[^1].children[^1])
      addJsonNode(level, value)

template loadjvalue(statement: untyped): untyped =
  if level.len() > 0:
    `statement`

proc addJsonNode(level: var seq[NodeRef], jobj: JsonNode) =
  for key, value in jobj.pairs():
    case key
    # Default nodes
    of "Node":
      loadnode(Node)
    of "Scene":
      loadnode(Scene)
    of "Canvas":
      loadnode(Canvas)

    # Control nodes
    of "Control":
      loadnode(Control)
    of "ColorRect":
      loadnode(ColorRect)
    of "TextureRect":
      loadnode(TextureRect)
    of "Label":
      loadnode(Label)
    of "Box":
      loadnode(Box)

    # properties
    of "name":
      loadjvalue:
        level[^1].name = getStr(value)
    of "color":
      loadjvalue(level[^1].ColorRectRef.setColor(Color(getStr(value))))
    of "position_anchor":
      loadjvalue(level[^1].ControlRef.setAnchor(
        getFloat(value["x1"]), getFloat(value["y1"]), getFloat(value["x2"]), getFloat(value["y2"])
      ))
    of "rect_size":
      loadjvalue(level[^1].ControlRef.resize(getFloat(value["x"]), getFloat(value["y"])))
    of "rect_position":
      loadjvalue(level[^1].ControlRef.move(getFloat(value["x"]), getFloat(value["y"])))
    of "text":
      loadjvalue(level[^1].LabelRef.setText(getStr(value)))
    of "texture":
      loadjvalue(level[^1].TextureRectRef.loadTexture(getStr(value)))
    of "size_anchor":
      loadjvalue(level[^1].ControlRef.setSizeAnchor(getFloat(value["x"]), getFloat(value["y"])))

    # childs
    of "children":
      if value.kind == JArray:
        for i in value.items():
          addJsonNode(level, i)
    else:
      discard
  if level.len() > 0:
    discard level.pop()

proc json2node*(src: string): SceneRef =
  ## Converts JSON string to the new Scene object.
  ##
  ## Arguments:
  ## - `src` is a source JSON string.
  result = Scene()
  var
    jobj = parseJson(src)
    level: seq[NodeRef] = @[]
  level.add(result)
  addJsonNode(level, jobj)

proc loadScene*(file: string): SceneRef =
  ## Loads a new Scene object from JSON file.
  ##
  ## Arguments:
  ## - `file` is a JSON file path.
  var
    f = open(file, fmRead)
    readed = f.readAll()
  f.close()
  result = json2node(readed)
