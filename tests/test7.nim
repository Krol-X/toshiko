# --- Test 7. Use NimObject. --- #
import toshiko


var test = nimobj()

test = 17
assert test.int == 17
test = "hello"
assert test.string == "hello"

test = tonimobj(@[1, 0.1, false])
echo repr(test)

var other = nimobj()
test = 2
other = 6
assert (test + other).int == 8
assert (test - other).int == -4


class TestClass:
  one = 5
  two = "hello"

echo dir(TestClass)
echo repr(TestClass)
