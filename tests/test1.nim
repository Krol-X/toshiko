# --- Test 1. Use Node object. --- #
import toshiko


var
  root = Node("Root")
  just_node = Node("Just Node")
  smth = Node("something")
  test_node = Node("Test Node")
  duplicated_test_node = test_node.duplicate()

assert duplicated_test_node.name == test_node.name
assert duplicated_test_node != test_node

root.addChild(just_node)
root.addChild(smth)
smth.addChild(test_node)
just_node.addChild(duplicated_test_node)

assert test_node.getPath() == "Root/something/Test Node"
assert duplicated_test_node.getPath() == "Root/Just Node/Test Node"

assert test_node in smth
assert test_node notin just_node
