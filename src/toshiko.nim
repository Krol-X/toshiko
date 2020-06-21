import
  toshiko/thirdparty,
  toshiko/window,
  toshiko/environment,
  toshiko/core,
  toshiko/nodes,
  toshiko/graphics,
  toshiko/control,
  toshiko/parsenode,
  os,
  parsecfg,
  strutils

export
  window, environment, core, nodes, thirdparty,
  graphics, control, parsenode


# Read config
if existsFile("global_settings.toshiko"):
  var cfg = loadConfig("global_settings.toshiko")
  setStandardFont(
    cfg.getSectionValue("GUI", "standard-font").cstring,
    parseInt(cfg.getSectionValue("GUI", "standard-font-size")).cint
  )
