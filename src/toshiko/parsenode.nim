# author: Ethosa
## Provides JSON to Node.
import
  json,
  parsejson,
  xmlparser,
  xmltree,
  strtabs,
  strutils,
  nodes,
  control,
  core


template loadjsonnode(fn: untyped): untyped =
  if level.len() > 0:
    level[^1].addChild(`fn`())
    if value.kind == JObject:
      level.add(level[^1].children[^1])
      addJsonNode(level, value)

template loadxmlnode(fn: untyped): untyped =
  if level.len() > 0:
    level[^1].addChild(`fn`())

template loadvalue(statement: untyped): untyped =
  if level.len() > 0:
    `statement`


proc addJsonNode(level: var seq[NodeRef], jobj: JsonNode) =
  for key, value in jobj.pairs():
    case key
    # Default nodes
    of "Node":
      loadjsonnode(Node)
    of "Scene":
      loadjsonnode(Scene)
    of "Canvas":
      loadjsonnode(Canvas)

    # Control nodes
    of "Control":
      loadjsonnode(Control)
    of "ColorRect":
      loadjsonnode(ColorRect)
    of "TextureRect":
      loadjsonnode(TextureRect)
    of "Label":
      loadjsonnode(Label)
    of "Box":
      loadjsonnode(Box)

    # properties
    of "name":
      loadvalue:
        level[^1].name = getStr(value)
    of "color":
      loadvalue(level[^1].ColorRectRef.setColor(Color(getStr(value))))
    of "position_anchor":
      loadvalue(level[^1].ControlRef.setAnchor(Anchor(
        getFloat(value["x1"]), getFloat(value["y1"]), getFloat(value["x2"]), getFloat(value["y2"])
      )))
    of "rect_size":
      loadvalue(level[^1].ControlRef.resize(getFloat(value["x"]), getFloat(value["y"])))
    of "rect_position":
      loadvalue(level[^1].ControlRef.move(getFloat(value["x"]), getFloat(value["y"])))
    of "text":
      loadvalue(level[^1].LabelRef.setText(getStr(value)))
    of "texture":
      loadvalue(level[^1].TextureRectRef.loadTexture(getStr(value)))
    of "size_anchor":
      loadvalue(level[^1].ControlRef.setSizeAnchor(Vector2(getFloat(value["x"]), getFloat(value["y"]))))

    # childs
    of "children":
      if value.kind == JArray:
        for i in value.items():
          addJsonNode(level, i)
    else:
      discard
  if level.len() > 0:
    discard level.pop()


proc addXmlNode(level: var seq[NodeRef], jobj: XmlNode) =
  for xml in jobj.items():
    case xml.tag
    # Default nodes
    of "Node":
      loadxmlnode(Node)
    of "Scene":
      loadxmlnode(Scene)
    of "Canvas":
      loadxmlnode(Canvas)

    # Control nodes
    of "Control":
      loadxmlnode(Control)
    of "ColorRect":
      loadxmlnode(ColorRect)
    of "TextureRect":
      loadxmlnode(TextureRect)
    of "Label":
      loadxmlnode(Label)
    of "Box":
      loadxmlnode(Box)
    else:
      discard

    level.add(level[^1].children[^1])
    for key, value in xml.attrs.pairs:  # properties
      case key
      of "name":
        loadvalue:
          level[^1].name = value
      of "color":
        loadvalue(level[^1].ColorRectRef.setColor(Color(value)))
      of "position_anchor":
        let tmp = value.split(Whitespace)
        loadvalue(level[^1].ControlRef.setAnchor(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]), parseFloat(tmp[2]), parseFloat(tmp[3])
        )))
      of "rect_size":
        let tmp = value.split(Whitespace)
        loadvalue(level[^1].ControlRef.resize(parseFloat(tmp[0]), parseFloat(tmp[1])))
      of "rect_position":
        let tmp = value.split(Whitespace)
        loadvalue(level[^1].ControlRef.move(parseFloat(tmp[0]), parseFloat(tmp[1])))
      of "text":
        loadvalue(level[^1].LabelRef.setText(value))
      of "texture":
        loadvalue(level[^1].TextureRectRef.loadTexture(value))
      of "size_anchor":
        let tmp = value.split(Whitespace)
        loadvalue(level[^1].ControlRef.setSizeAnchor(Vector2(parseFloat(tmp[0]), parseFloat(tmp[1]))))

    for child in jobj.items():  # children
      addXmlNode(level, child)
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

proc xml2node*(src: string): SceneRef =
  ## COnverts XML string to he new Scene object.
  ##
  ## Arguments:
  ## - `src` is a source XML string.
  result = Scene()
  var
    jobj = parseXml(src)
    level: seq[NodeRef] = @[]
  level.add(result)
  addXmlNode(level, jobj)

proc loadScene*(file: string): SceneRef =
  ## Loads a new Scene object from JSON or XML file.
  ##
  ## Arguments:
  ## - `file` is a JSON file path.
  var
    f = open(file, fmRead)
    readed = f.readAll()
  f.close()
  try:
    result = json2node(readed)
  except JsonParsingError:
    result = xml2node(readed)
  except XmlError:
    when defined(debug):
      echo "file \"" & file & "\" not contains XML or JSON."
    result = Scene()
