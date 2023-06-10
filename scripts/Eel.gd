const Defs = preload("res://scripts/Defs.gd")

var pos : Vector2i
var color : Defs.EelColor

func _init(p: Vector2i, c: Defs.EelColor):
    pos = p
    color = c

func _to_string():
    var out = ""
    out += "[" + \
    "pos: " + str(pos) + ", " + \
    "col: " + str(color) + \
    "] "
    return out