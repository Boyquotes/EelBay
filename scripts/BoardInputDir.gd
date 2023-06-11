extends TileMap

const Def = preload("res://scripts/Def.gd")

@export var is_cell_selected : bool = false
@export var selected_cell : Vector2i

signal move_triggered(move_dir: Def.MoveDir, start_pos: Vector2i)

# TODO: Move to separate tilemap that handles input independent of display tilemaps
func _input(event):
    if event is InputEventMouseButton:
        var pos = event.position
        var pos_local = to_local(pos)
        if event.pressed:
            # Mouse down
            var target_cell = local_to_map(pos_local)

            is_cell_selected = true
            selected_cell = target_cell
        else:
            # Mouse up
            pass

func _process(_delta):
    if not is_cell_selected:
        return

    if Input.is_action_just_pressed("move_left"):
        move_triggered.emit(Def.MoveDir.MoveW, selected_cell)
    elif Input.is_action_just_pressed("move_up"):
        move_triggered.emit(Def.MoveDir.MoveN, selected_cell)
    elif Input.is_action_just_pressed("move_right"):
        move_triggered.emit(Def.MoveDir.MoveE, selected_cell)
    elif Input.is_action_just_pressed("move_down"):
        move_triggered.emit(Def.MoveDir.MoveS, selected_cell)
