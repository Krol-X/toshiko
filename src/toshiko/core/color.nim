# author: Ethosa
import
  strutils,
  re


type
  ColorObj* = object
    r*, g*, b*, a*: float
  ColorRef* = ref ColorObj

var color_names = {
  "airforceblue": ColorRef(r: 0.36, g: 0.54, b: 0.66, a: 1),
  "aliceblue": ColorRef(r: 0.94, g: 0.97, b: 1.00, a: 1),
  "alizarincrimson": ColorRef(r: 0.89, g: 0.15, b: 0.21, a: 1),
  "almond": ColorRef(r: 0.94, g: 0.87, b: 0.80, a: 1),
  "amaranth": ColorRef(r: 0.90, g: 0.17, b: 0.31, a: 1),
  "amber": ColorRef(r: 1.00, g: 0.75, b: 0.00, a: 1),
  "americanrose": ColorRef(r: 1.00, g: 0.01, b: 0.24, a: 1),
  "amethyst": ColorRef(r: 0.60, g: 0.40, b: 0.80, a: 1),
  "anti-flashwhite": ColorRef(r: 0.95, g: 0.95, b: 0.96, a: 1),
  "antiquewhite": ColorRef(r: 0.98, g: 0.92, b: 0.84, a: 1),
  "applegreen": ColorRef(r: 0.55, g: 0.71, b: 0.00, a: 1),
  "asparagus": ColorRef(r: 0.48, g: 0.63, b: 0.36, a: 1),
  "aqua": ColorRef(r: 0.00, g: 1.00, b: 1.00, a: 1),
  "aquamarine": ColorRef(r: 0.50, g: 1.00, b: 0.83, a: 1),
  "armygreen": ColorRef(r: 0.29, g: 0.33, b: 0.13, a: 1),
  "arsenic": ColorRef(r: 0.23, g: 0.27, b: 0.29, a: 1),
  "azure": ColorRef(r: 0.00, g: 0.50, b: 1.00, a: 1),
  "battleshipgrey": ColorRef(r: 0.52, g: 0.52, b: 0.51, a: 1),
  "beige": ColorRef(r: 0.96, g: 0.96, b: 0.86, a: 1),
  "bistre": ColorRef(r: 0.24, g: 0.17, b: 0.12, a: 1),
  "bittersweet": ColorRef(r: 1.00, g: 0.44, b: 0.37, a: 1),
  "black": ColorRef(r: 0.00, g: 0.00, b: 0.00, a: 1),
  "blond": ColorRef(r: 0.98, g: 0.94, b: 0.75, a: 1),
  "blue": ColorRef(r: 0.00, g: 0.00, b: 1.00, a: 1),
  "bondiblue": ColorRef(r: 0.00, g: 0.58, b: 0.71, a: 1),
  "bostonuniversityred": ColorRef(r: 0.80, g: 0.00, b: 0.00, a: 1),
  "brass": ColorRef(r: 0.71, g: 0.65, b: 0.26, a: 1),
  "brightgreen": ColorRef(r: 0.40, g: 1.00, b: 0.00, a: 1),
  "brightturquoise": ColorRef(r: 0.03, g: 0.91, b: 0.87, a: 1),
  "brightviolet": ColorRef(r: 0.80, g: 0.00, b: 0.80, a: 1),
  "bronze": ColorRef(r: 0.80, g: 0.50, b: 0.20, a: 1),
  "brown": ColorRef(r: 0.59, g: 0.29, b: 0.00, a: 1),
  "buff": ColorRef(r: 0.94, g: 0.86, b: 0.51, a: 1),
  "burgundy": ColorRef(r: 0.56, g: 0.00, b: 0.13, a: 1),
  "burntorange": ColorRef(r: 0.80, g: 0.33, b: 0.00, a: 1),
  "burntsienna": ColorRef(r: 0.91, g: 0.45, b: 0.32, a: 1),
  "burntumber": ColorRef(r: 0.54, g: 0.20, b: 0.14, a: 1),
  "camel": ColorRef(r: 0.76, g: 0.60, b: 0.42, a: 1),
  "camouflagegreen": ColorRef(r: 0.47, g: 0.53, b: 0.42, a: 1),
  "canonicalaubergine": ColorRef(r: 0.47, g: 0.16, b: 0.33, a: 1),
  "cardinal": ColorRef(r: 0.77, g: 0.12, b: 0.23, a: 1),
  "carmine": ColorRef(r: 0.59, g: 0.00, b: 0.09, a: 1),
  "carrot": ColorRef(r: 0.93, g: 0.57, b: 0.13, a: 1),
  "celadon": ColorRef(r: 0.67, g: 0.88, b: 0.69, a: 1),
  "cerise": ColorRef(r: 0.87, g: 0.19, b: 0.39, a: 1),
  "cerulean": ColorRef(r: 0.00, g: 0.48, b: 0.65, a: 1),
  "ceruleanblue": ColorRef(r: 0.16, g: 0.32, b: 0.75, a: 1),
  "chartreuse": ColorRef(r: 0.50, g: 1.00, b: 0.00, a: 1),
  "chestnut": ColorRef(r: 0.80, g: 0.36, b: 0.36, a: 1),
  "chocolate": ColorRef(r: 0.82, g: 0.41, b: 0.12, a: 1),
  "cinnamon": ColorRef(r: 0.48, g: 0.25, b: 0.00, a: 1),
  "cobalt": ColorRef(r: 0.00, g: 0.28, b: 0.67, a: 1),
  "copper": ColorRef(r: 0.72, g: 0.45, b: 0.20, a: 1),
  "coral": ColorRef(r: 1.00, g: 0.50, b: 0.31, a: 1),
  "corn": ColorRef(r: 0.98, g: 0.93, b: 0.36, a: 1),
  "cornflowerblue": ColorRef(r: 0.39, g: 0.58, b: 0.93, a: 1),
  "cream": ColorRef(r: 1.00, g: 0.99, b: 0.82, a: 1),
  "crimson": ColorRef(r: 0.86, g: 0.08, b: 0.24, a: 1),
  "cyan": ColorRef(r: 0.00, g: 1.00, b: 1.00, a: 1),
  "darkblue": ColorRef(r: 0.00, g: 0.00, b: 0.55, a: 1),
  "darkbrown": ColorRef(r: 0.40, g: 0.26, b: 0.13, a: 1),
  "darkcerulean": ColorRef(r: 0.03, g: 0.27, b: 0.49, a: 1),
  "darkchestnut": ColorRef(r: 0.60, g: 0.41, b: 0.38, a: 1),
  "darkcoral": ColorRef(r: 0.80, g: 0.36, b: 0.27, a: 1),
  "darkgoldenrod": ColorRef(r: 0.72, g: 0.53, b: 0.04, a: 1),
  "darkgreen": ColorRef(r: 0.00, g: 0.20, b: 0.13, a: 1),
  "darkindigo": ColorRef(r: 0.19, g: 0.00, b: 0.38, a: 1),
  "darkkhaki": ColorRef(r: 0.74, g: 0.72, b: 0.42, a: 1),
  "darkolive": ColorRef(r: 0.33, g: 0.41, b: 0.20, a: 1),
  "darkpastelgreen": ColorRef(r: 0.01, g: 0.75, b: 0.24, a: 1),
  "darkpeach": ColorRef(r: 1.00, g: 0.85, b: 0.73, a: 1),
  "darkpink": ColorRef(r: 0.91, g: 0.33, b: 0.50, a: 1),
  "darkpowderblue": ColorRef(r: 0.00, g: 0.20, b: 0.60, a: 1),
  "darksalmon": ColorRef(r: 0.91, g: 0.59, b: 0.48, a: 1),
  "darkscarlet": ColorRef(r: 0.34, g: 0.01, b: 0.10, a: 1),
  "darkslategray": ColorRef(r: 0.18, g: 0.31, b: 0.31, a: 1),
  "darkspringgreen": ColorRef(r: 0.09, g: 0.45, b: 0.27, a: 1),
  "darktan": ColorRef(r: 0.57, g: 0.51, b: 0.32, a: 1),
  "darktangerine": ColorRef(r: 1.00, g: 0.66, b: 0.07, a: 1),
  "darkteagreen": ColorRef(r: 0.73, g: 0.86, b: 0.68, a: 1),
  "darkturquoise": ColorRef(r: 0.07, g: 0.38, b: 0.38, a: 1),
  "darkviolet": ColorRef(r: 0.26, g: 0.19, b: 0.54, a: 1),
  "deeppink": ColorRef(r: 1.00, g: 0.08, b: 0.58, a: 1),
  "deepskyblue": ColorRef(r: 0.00, g: 0.75, b: 1.00, a: 1),
  "denim": ColorRef(r: 0.08, g: 0.38, b: 0.74, a: 1),
  "dodgerblue": ColorRef(r: 0.12, g: 0.56, b: 1.00, a: 1),
  "emerald": ColorRef(r: 0.31, g: 0.78, b: 0.47, a: 1),
  "eggplant": ColorRef(r: 0.60, g: 0.00, b: 0.40, a: 1),
  "fawn": ColorRef(r: 0.90, g: 0.67, b: 0.44, a: 1),
  "ferngreen": ColorRef(r: 0.31, g: 0.47, b: 0.26, a: 1),
  "firebrick": ColorRef(r: 0.70, g: 0.13, b: 0.13, a: 1),
  "flax": ColorRef(r: 0.93, g: 0.86, b: 0.51, a: 1),
  "fuchsia": ColorRef(r: 1.00, g: 0.00, b: 1.00, a: 1),
  "gamboge": ColorRef(r: 0.89, g: 0.61, b: 0.06, a: 1),
  "gold": ColorRef(r: 1.00, g: 0.84, b: 0.00, a: 1),
  "goldenrod": ColorRef(r: 0.85, g: 0.65, b: 0.13, a: 1),
  "gray": ColorRef(r: 0.50, g: 0.50, b: 0.50, a: 1),
  "gray-asparagus": ColorRef(r: 0.27, g: 0.35, b: 0.27, a: 1),
  "gray-teagreen": ColorRef(r: 0.79, g: 0.85, b: 0.73, a: 1),
  "green": ColorRef(r: 0.00, g: 1.00, b: 0.00, a: 1),
  "green-yellow": ColorRef(r: 0.68, g: 1.00, b: 0.18, a: 1),
  "gradusblue": ColorRef(r: 0.00, g: 0.49, b: 1.00, a: 1),
  "heliotrope": ColorRef(r: 0.87, g: 0.45, b: 1.00, a: 1),
  "hotpink": ColorRef(r: 0.99, g: 0.06, b: 0.75, a: 1),
  "indigo": ColorRef(r: 0.29, g: 0.00, b: 0.51, a: 1),
  "internationalorange": ColorRef(r: 1.00, g: 0.31, b: 0.00, a: 1),
  "indianred": ColorRef(r: 0.80, g: 0.36, b: 0.36, a: 1),
  "jade": ColorRef(r: 0.00, g: 0.66, b: 0.42, a: 1),
  "khaki": ColorRef(r: 0.76, g: 0.69, b: 0.57, a: 1),
  "kleinblue": ColorRef(r: 0.23, g: 0.46, b: 0.77, a: 1),
  "lavender": ColorRef(r: 0.90, g: 0.90, b: 0.98, a: 1),
  "lavenderblush": ColorRef(r: 1.00, g: 0.94, b: 0.96, a: 1),
  "lemon": ColorRef(r: 0.99, g: 0.91, b: 0.06, a: 1),
  "lemoncream": ColorRef(r: 1.00, g: 0.98, b: 0.80, a: 1),
  "lightbrown": ColorRef(r: 0.80, g: 0.52, b: 0.25, a: 1),
  "lilac": ColorRef(r: 0.78, g: 0.64, b: 0.78, a: 1),
  "lime": ColorRef(r: 0.80, g: 1.00, b: 0.00, a: 1),
  "linen": ColorRef(r: 0.98, g: 0.94, b: 0.90, a: 1),
  "lawngreen": ColorRef(r: 0.49, g: 0.99, b: 0.00, a: 1),
  "magenta": ColorRef(r: 1.00, g: 0.00, b: 1.00, a: 1),
  "malachite": ColorRef(r: 0.04, g: 0.85, b: 0.32, a: 1),
  "maroon": ColorRef(r: 0.50, g: 0.00, b: 0.00, a: 1),
  "mauve": ColorRef(r: 0.60, g: 0.20, b: 0.40, a: 1),
  "midnightblue": ColorRef(r: 0.00, g: 0.20, b: 0.40, a: 1),
  "mintgreen": ColorRef(r: 0.60, g: 1.00, b: 0.60, a: 1),
  "mossgreen": ColorRef(r: 0.68, g: 0.87, b: 0.68, a: 1),
  "mountbattenpink": ColorRef(r: 0.60, g: 0.48, b: 0.55, a: 1),
  "mustard": ColorRef(r: 1.00, g: 0.86, b: 0.35, a: 1),
  "navajowhite": ColorRef(r: 1.00, g: 0.87, b: 0.68, a: 1),
  "navy": ColorRef(r: 0.00, g: 0.00, b: 0.50, a: 1),
  "ochre": ColorRef(r: 0.80, g: 0.47, b: 0.13, a: 1),
  "oldgold": ColorRef(r: 0.81, g: 0.71, b: 0.23, a: 1),
  "olive": ColorRef(r: 0.50, g: 0.50, b: 0.00, a: 1),
  "olivedrab": ColorRef(r: 0.42, g: 0.56, b: 0.14, a: 1),
  "orange": ColorRef(r: 1.00, g: 0.65, b: 0.00, a: 1),
  "orchid": ColorRef(r: 0.85, g: 0.44, b: 0.84, a: 1),
  "oldlace": ColorRef(r: 0.99, g: 0.96, b: 0.90, a: 1),
  "paleblue": ColorRef(r: 0.69, g: 0.93, b: 0.93, a: 1),
  "palebrown": ColorRef(r: 0.60, g: 0.46, b: 0.33, a: 1),
  "palecarmine": ColorRef(r: 0.69, g: 0.25, b: 0.21, a: 1),
  "palechestnut": ColorRef(r: 0.87, g: 0.68, b: 0.69, a: 1),
  "palecornflowerblue": ColorRef(r: 0.67, g: 0.80, b: 0.94, a: 1),
  "palemagenta": ColorRef(r: 0.98, g: 0.52, b: 0.90, a: 1),
  "palemauve": ColorRef(r: 0.60, g: 0.40, b: 0.40, a: 1),
  "palepink": ColorRef(r: 0.98, g: 0.85, b: 0.87, a: 1),
  "palered-violet": ColorRef(r: 0.86, g: 0.44, b: 0.58, a: 1),
  "palesandybrown": ColorRef(r: 0.85, g: 0.74, b: 0.67, a: 1),
  "paleyellow": ColorRef(r: 0.94, g: 0.86, b: 0.51, a: 1),
  "pang": ColorRef(r: 0.78, g: 0.99, b: 0.93, a: 1),
  "papayawhip": ColorRef(r: 1.00, g: 0.94, b: 0.84, a: 1),
  "pastelgreen": ColorRef(r: 0.47, g: 0.87, b: 0.47, a: 1),
  "pastelpink": ColorRef(r: 1.00, g: 0.82, b: 0.86, a: 1),
  "peach": ColorRef(r: 1.00, g: 0.90, b: 0.71, a: 1),
  "peach-orange": ColorRef(r: 1.00, g: 0.80, b: 0.60, a: 1),
  "peach-yellow": ColorRef(r: 0.98, g: 0.87, b: 0.68, a: 1),
  "pear": ColorRef(r: 0.82, g: 0.89, b: 0.19, a: 1),
  "periwinkle": ColorRef(r: 0.80, g: 0.80, b: 1.00, a: 1),
  "persianblue": ColorRef(r: 0.40, g: 0.00, b: 1.00, a: 1),
  "pinegreen": ColorRef(r: 0.00, g: 0.47, b: 0.44, a: 1),
  "pink": ColorRef(r: 1.00, g: 0.75, b: 0.80, a: 1),
  "pink-orange": ColorRef(r: 1.00, g: 0.60, b: 0.40, a: 1),
  "plum": ColorRef(r: 0.40, g: 0.00, b: 0.40, a: 1),
  "powderblue": ColorRef(r: 0.62, g: 0.73, b: 0.83, a: 1),
  "puce": ColorRef(r: 0.80, g: 0.53, b: 0.60, a: 1),
  "prussianblue": ColorRef(r: 0.00, g: 0.19, b: 0.33, a: 1),
  "pumpkin": ColorRef(r: 1.00, g: 0.46, b: 0.09, a: 1),
  "rawumber": ColorRef(r: 0.45, g: 0.29, b: 0.07, a: 1),
  "red": ColorRef(r: 1.00, g: 0.00, b: 0.00, a: 1),
  "red-violet": ColorRef(r: 0.78, g: 0.08, b: 0.52, a: 1),
  "robineggblue": ColorRef(r: 0.00, g: 0.80, b: 0.80, a: 1),
  "royalblue": ColorRef(r: 0.25, g: 0.41, b: 0.88, a: 1),
  "russet": ColorRef(r: 0.46, g: 0.35, b: 0.34, a: 1),
  "rust": ColorRef(r: 0.72, g: 0.25, b: 0.05, a: 1),
  "rosybrown": ColorRef(r: 0.74, g: 0.56, b: 0.56, a: 1),
  "safetyorange": ColorRef(r: 1.00, g: 0.60, b: 0.00, a: 1),
  "saffron": ColorRef(r: 0.96, g: 0.77, b: 0.19, a: 1),
  "sapphire": ColorRef(r: 0.03, g: 0.15, b: 0.40, a: 1),
  "sana": ColorRef(r: 0.82, g: 0.53, b: 0.78, a: 1),
  "salmon": ColorRef(r: 1.00, g: 0.22, b: 0.41, a: 1),
  "sandybrown": ColorRef(r: 0.96, g: 0.64, b: 0.38, a: 1),
  "sangria": ColorRef(r: 0.57, g: 0.00, b: 0.04, a: 1),
  "scarlet": ColorRef(r: 1.00, g: 0.14, b: 0.00, a: 1),
  "schoolbusyellow": ColorRef(r: 1.00, g: 0.85, b: 0.00, a: 1),
  "seagreen": ColorRef(r: 0.18, g: 0.55, b: 0.34, a: 1),
  "seashell": ColorRef(r: 1.00, g: 0.96, b: 0.93, a: 1),
  "selectiveyellow": ColorRef(r: 1.00, g: 0.73, b: 0.00, a: 1),
  "sepia": ColorRef(r: 0.44, g: 0.26, b: 0.08, a: 1),
  "silver": ColorRef(r: 0.75, g: 0.75, b: 0.75, a: 1),
  "slategray": ColorRef(r: 0.44, g: 0.50, b: 0.56, a: 1),
  "springgreen": ColorRef(r: 0.00, g: 1.00, b: 0.50, a: 1),
  "steelblue": ColorRef(r: 0.27, g: 0.51, b: 0.71, a: 1),
  "swampgreen": ColorRef(r: 0.67, g: 0.72, b: 0.56, a: 1),
  "tan": ColorRef(r: 0.82, g: 0.71, b: 0.55, a: 1),
  "tenné": ColorRef(r: 0.80, g: 0.34, b: 0.00, a: 1),
  "tangerine": ColorRef(r: 1.00, g: 0.80, b: 0.00, a: 1),
  "teagreen": ColorRef(r: 0.82, g: 0.94, b: 0.75, a: 1),
  "teal": ColorRef(r: 0.00, g: 0.50, b: 0.50, a: 1),
  "thistle": ColorRef(r: 0.85, g: 0.75, b: 0.85, a: 1),
  "turquoise": ColorRef(r: 0.19, g: 0.84, b: 0.78, a: 1),
  "titian": ColorRef(r: 0.84, g: 0.24, b: 0.03, a: 1),
  "transportred": ColorRef(r: 0.80, g: 0.02, b: 0.02, a: 1),
  "tomato": ColorRef(r: 1.00, g: 0.39, b: 0.28, a: 1),
  "ultramarine": ColorRef(r: 0.07, g: 0.04, b: 0.56, a: 1),
  "unitednationsblue": ColorRef(r: 0.36, g: 0.57, b: 0.90, a: 1),
  "ubuntuorange": ColorRef(r: 0.87, g: 0.28, b: 0.08, a: 1),
  "vanilla": ColorRef(r: 0.95, g: 0.90, b: 0.67, a: 1),
  "vermilion": ColorRef(r: 0.89, g: 0.26, b: 0.20, a: 1),
  "violet": ColorRef(r: 0.55, g: 0.00, b: 1.00, a: 1),
  "violet-eggplant": ColorRef(r: 0.60, g: 0.07, b: 0.60, a: 1),
  "viridian": ColorRef(r: 0.25, g: 0.51, b: 0.43, a: 1),
  "wheat": ColorRef(r: 0.96, g: 0.87, b: 0.70, a: 1),
  "white": ColorRef(r: 1.00, g: 1.00, b: 1.00, a: 1),
  "wisteria": ColorRef(r: 0.79, g: 0.63, b: 0.86, a: 1),
  "wine": ColorRef(r: 0.45, g: 0.18, b: 0.22, a: 1),
  "xanadu": ColorRef(r: 0.45, g: 0.53, b: 0.47, a: 1),
  "yellow": ColorRef(r: 1.00, g: 1.00, b: 0.00, a: 1),
  "zinnwaldite": ColorRef(r: 0.92, g: 0.76, b: 0.69, a: 1),
  "zaffre": ColorRef(r: 0.00, g: 0.08, b: 0.66, a: 1)
}

proc Color*(r, g, b, a: float): ColorRef =
  runnableExamples:
    var clr = Color(0f, 1f, 1f, 0.5)
  ColorRef(r: r, g: g, b: b, a: a)

proc Color*(r, g, b: float): ColorRef =
  runnableExamples:
    var clr = Color(1f, 1f, 1f)
  Color(r, g, b, 1)

proc Color*(rgb: float): ColorRef =
  runnableExamples:
    var clr = Color(1f)
  Color(rgb, rgb, rgb, 1)

proc Color*(clr: ColorRef): ColorRef =
  runnableExamples:
    var clr = Color(Color(1f, 1f, 1f, 1f))
  Color(clr.r, clr.g, clr.b, clr.a)

proc Color*: ColorRef =
  runnableExamples:
    var clr = Color()
  Color(0, 0, 0, 0)

proc Color*(r, g, b, a: int): ColorRef =
  runnableExamples:
    var clr = Color(255, 255, 255, 255)
  Color(r / 255, g / 255, b / 255, a / 255)

proc Color*(r, g, b: int, a: float): ColorRef =
  runnableExamples:
    var clr = Color(255, 255, 255, 1f)
  Color(r / 255, g / 255, b / 255, a)

proc Color*(r, g, b: int): ColorRef =
  runnableExamples:
    var clr = Color(255, 255, 255)
  Color(r, g, b, 1f)

proc Color*(hexint: int): ColorRef =
  runnableExamples:
    var clr = Color(0xFF64CCFF'i32)
  Color(
    ((hexint shr 24) and 255) / 255,
    ((hexint shr 16) and 255) / 255,
    ((hexint shr 8) and 255) / 255,
    (hexint and 255) / 255
  )


proc Color*(hexstr: string): ColorRef =
  runnableExamples:
    var
      hex1 = Color("#f6f")
      hex2 = Color("#f77ff7")
      hex3 = Color("#7ff77fff")
      named = Color("red")
      rgb = Color("rgb(255, 255, 255)")
      rgba = Color("rgba(255, 255, 255, 1.0)")
  var target = hexstr
  var matched: array[20, string]

  # #FFFFFFFF, #FFF, #FFFFFF, etc
  if target.startsWith('#') or target.startsWith("0x") or target.startsWith("0X"):
    target = target[1..^1]
    if target[0] == 'x' or target[0] == 'X':
      target = target[1..^1]

    if target.len() == 3:  # #fff -> #ffffffff
      target = target[0] & target[0] & target[1] & target[1] & target[2] & target[2] & "ff"
    elif target.len() == 6:  # #ffffff -> #ffffffff
      target &= "ff"
    return Color(parseHexInt(target))

  # rgba(255, 255, 255, 1.0)
  elif target.match(re"\A\s*rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+.?\d*?)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]), parseInt(matched[1]), parseInt(matched[2]), parseFloat(matched[3]))

  # rgb(255, 255, 255)
  elif target.match(re"\A\s*rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*\Z", matched):
    return Color(parseInt(matched[0]), parseInt(matched[1]), parseInt(matched[2]))

  # name color, e.g. white, red, violet, turquoise, etc.
  else:
    var colorname = target.toLowerAscii().replace(" ", "")
    for i in color_names:
      if i[0] == colorname:
        return i[1]


proc normalize*(a: ColorRef) =
  ## Normalizes color.
  runnableExamples:
    var clr = Color(-1f, 0.5, 10f)
    clr.normalize()
    echo clr
    assert clr == Color(0f, 0.5, 1f)
  a.r = if a.r > 1f: 1f elif a.r < 0f: 0f else: a.r
  a.g = if a.g > 1f: 1f elif a.g < 0f: 0f else: a.g
  a.b = if a.b > 1f: 1f elif a.b < 0f: 0f else: a.b
  a.a = if a.a > 1f: 1f elif a.a < 0f: 0f else: a.a

proc normalized*(a: ColorRef): ColorRef =
  result = Color(a)
  result.normalize


proc `$`*(a: ColorRef): string =
  "Color(" & $a.r & ", " & $a.g & ", " & $a.b & ", " & $a.a & ")"

proc `==`*(a, b: ColorRef): bool =
  a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
