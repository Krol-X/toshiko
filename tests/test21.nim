# --- Test 21. Use ProgressBar object. --- #
import toshiko


Window("Test 21")


build:
  - Scene main:
    # horizontal:
    - ProgressBar bar1:
      indeterminate: true
      value: 50
    - ProgressBar bar2:
      rect_position: Vector2(0, 21)
      value: 35
    # vertical:
    - ProgressBar bar3:
      value: 45
      rect_position: Vector2(121, 0)
      rect_size: Vector2(20, 120)
      progress_type: PROGRESS_BAR_VERTICAL
    - ProgressBar bar4:
      value: 45
      rect_position: Vector2(142, 0)
      rect_size: Vector2(20, 120)
      progress_type: PROGRESS_BAR_VERTICAL
      indeterminate: true


addMainScene(main)
showWindow()
