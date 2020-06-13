# --- Test 3. use custom properties --- #
import toshiko


var
  test_node = Node()

test_node.properties["test"] = 123
assert test_node.properties["test"].int == 123

test_node.properties["test"] = "test string"
assert test_node.properties["test"].string == "test string"

test_node.properties["my array"] = tonimobj(@[1, 0.1, true, "test"])
assert test_node.properties["my array"].len() == 4
