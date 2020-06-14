# author: Ethosa
import
  strutils,
  ../core/enums,
  ../core/nim_object


type
  NodeHandler* = proc(self: NodeRef): void
  NodeObj* = object of RootObj
    is_ready*: bool
    name*: string
    kind*: NodeKind
    nodetype*: NodeType
    pausemode*: PauseMode
    parent*: NodeRef
    children*: seq[NodeRef]

    # handlers
    on_enter*: NodeHandler  ## Called, when entered in the scene.
    on_exit*: NodeHandler  ## Called, when exited from the scene.
    on_ready*: NodeHandler  ## Called after `on_enter`.
    on_process*: NodeHandler  ## Called every tick.

    properties*: NimRef  ## Custom properties. You can change it at any time.
  NodeRef* = ref NodeObj

var standard_handler*: NodeHandler = proc(self: NodeRef) = discard


template nodepattern*(t: untyped) =
  result = `t`()
  result.is_ready = false
  result.name = name
  result.children = @[]
  result.nodetype = NODETYPE_DEFAULT
  result.pausemode = PAUSE_MODE_INHERIT

  result.on_enter = standard_handler
  result.on_exit = standard_handler
  result.on_ready = standard_handler
  result.on_process = standard_handler

  result.properties = nimtype()


proc Node*(name: string = "Node"): NodeRef =
  ## Creates a new Node object.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var test_node = Node("My node")
  nodepattern(NodeRef)
  result.kind = NODE_NODE


method draw*(self: NodeRef, w, h: float) {.base.} = discard
method handle*(self: NodeRef, mouse_on: NodeRef) {.base.} = discard


method addChild*(self, child: NodeRef) {.base.} =
  ## Adds a new child.
  if self == child:
    return
  self.children.add(child)
  child.parent = self

method addChilds*(self: NodeRef, childs: varargs[NodeRef]) {.base.} =
  ## Adds one or more childs.
  for child in childs:
    self.addChild(child)

template duplicate*(self: NodeRef): untyped =
  ## Duplicates Node object.
  ## It is an alias for deepCopy proc.
  self.deepCopy()

method getAllChilds*(self: NodeRef): seq[NodeRef] {.base.} =
  runnableExamples:
    var
      root = Node()
      child1 = Node()
      child2 = Node()
      child1_1 = Node()
      child2_1 = Node()
      child2_2 = Node()
    root.addChilds(child1, child2)
    child2.addChilds(child2_1, child2_2)
    child1.addChild(child1_1)
    assert root.getAllChilds == @[child1, child1_1, child2, child2_1, child2_2]
  result = @[]
  for child in self.children:
    if child notin result:
      result.add(child)
    if child.children.len() > 0:
      for node in child.getAllChilds():
        if node notin result:
          result.add(node)

method getChild*(self: NodeRef, index: int): NodeRef {.base.} =
  ## Gets child at specific position.
  self.children[index]

method getChildCount*(self: NodeRef): int {.base.} =
  return self.children.len()

method getChildPosition*(self, other: NodeRef): int {.base.} =
  ## Returns `other` position.
  for i in 0..self.children.high:
    if other == self.children[i]:
      return i

method getNode*(self: NodeRef, path: string): NodeRef {.base.} =
  ## Gets node by it name.
  result = self
  var p = path.split("/")

  for part in p:
    case part
    of "..":
      if result.parent != nil:
        result = result.parent
    else:
      for child in result.children:
        if child.name == part:
          result = child
          break

method getParent*(self: NodeRef): NodeRef {.base.} =
  ## Returns parent node, if available.
  if self.parent != nil:
    return self

method getPath*(self: NodeRef): string {.base.} =
  ## Returns full node path.
  var current = self
  result = self.name
  while current.parent != nil:
    current = current.parent
    result = current.name & "/" & result

method getPauseMode*(self: NodeRef): PauseMode {.base.} =
  result = self.pausemode
  var current = self

  while result == PAUSE_MODE_INHERIT and current.parent != nil:
    current = current.parent
    result = current.pausemode

  if result == PAUSE_MODE_INHERIT:
    result = PAUSE_MODE_PAUSE

method getRoot*(self: NodeRef): NodeRef {.base.} =
  ## Returns root node.
  result = self
  while result.parent != nil:
    result = result.parent

method hasNode*(self: NodeRef, name: string): bool {.base.} =
  ## Returns true, when node with name `name` in the `self` children.
  for child in self.children:
    if child.name == name:
      return true
  return false

method hasNode*(self, other: NodeRef): bool {.base.} =
  ## Returns true, when `other` in the `self` children.
  for child in self.children:
    if child == other:
      return true
  return false

method hasParent*(self: NodeRef): bool {.base.} =
  ## Returns true, when `self` has parent node.
  return self.parent != nil

method isParentOf*(self, other: NodeRef): bool {.base.} =
  ## Returns true, when `self` is a parent of `other`.
  return other in self.children

method remove*(self, other: NodeRef) {.base.} =
  ## Removes `other` from children, if available.
  for i in 0..self.children.high:
    if other == self.children[i]:
      self.children.delete(i)
      break


# --- Operators --- #
proc `~`*(self: NodeRef, path: string): NodeRef =
  ## Alias for `getNode <#getNode.e,NodeRef,string>`_ method.
  runnableExamples:
    var test_node = Node()
    discard test_node ~ "../../../hello"
  self.getNode(path)

proc contains*(self, other: NodeRef): bool =
  ## Alias for `hasNode <#hasNode.e,NodeRef,NodeRef>`_ method.
  runnableExamples:
    var test_node = Node()
    assert not (Node() in test_node)
  self.hasNode(other)


# --- Macros --- #
import macros


macro `@`*(node: NodeRef, callable, code: untyped): untyped =
  ## Convenient alias for handlers.
  ##
  ## ## Example
  ## .. code-block:: nim
  ##
  ##    var node = Node()
  ##    node@on_enter(self):
  ##      echo self.name
  # Gets event name.
  if callable.kind == nnkCall:
    case $callable[0]
    of "on_process", "on_ready", "on_enter", "on_exit":
      var
        name = callable[0]
        self = callable[1]
      result = quote do:
        `node`.`name` =
          proc(`self`: NodeRef): void =
            `code`
    else:
      discard
