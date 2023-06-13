const Def = preload("res://scripts/Def.gd")

var _pos : Vector2i
var _color : Def.EelColor

func _init(p: Vector2i, c: Def.EelColor):
    _pos = p
    _color = c

func _to_string():
    var out = ""
    out += "[" + \
    "pos: " + str(_pos) + ", " + \
    "col: " + str(_color) + \
    "] "
    return out