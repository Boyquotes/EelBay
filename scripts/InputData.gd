class_name InputData

const Def = preload("res://scripts/Def.gd")

var _move_dir : Def.MoveDir
var _start_pos : Vector2i

func _init(move_dir : Def.MoveDir, start_pos : Vector2i):
    _move_dir = move_dir
    _start_pos = start_pos