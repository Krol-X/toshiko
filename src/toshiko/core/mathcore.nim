# author: Ethosa

proc normalize*(value, min_value, max_value: float): float =
  if value > max_value:
    max_value
  elif value < min_value:
    min_value
  else:
    value
