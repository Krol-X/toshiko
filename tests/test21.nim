# --- Test 21. Use ProgressBar object. --- #
import toshiko


Window("Test 21")


build:
  - Scene main:
    - ProgressBar bar1:
      indeterminate: true
      value: 50
    - ProgressBar bar2:
      rect_position: Vector2(0, 21)
      value: 35


addMainScene(main)
showWindow()
