# author: Ethosa

proc normalize*(value, min_value, max_value: float): float =
  ## Returns `min_value`, when `value` < `min_value`.
  ## Returns `max_value`, when `value` > `max_value`.
  ## Returns `value`, when `min_value` < `value` < `max_value`.
  if value > max_value:
    max_value
  elif value < min_value:
    min_value
  else:
    value
