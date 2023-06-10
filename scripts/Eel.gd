const Def = preload("res://scripts/Def.gd")

var pos : Vector2i
var color : Def.EelColor

func _init(p: Vector2i, c: Def.EelColor):
    pos = p
    color = c

func _to_string():
    var out = ""
    out += "[" + \
    "pos: " + str(pos) + ", " + \
    "col: " + str(color) + \
    "] "
    return out