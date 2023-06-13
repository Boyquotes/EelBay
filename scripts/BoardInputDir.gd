extends TileMap

const Def = preload("res://scripts/Def.gd")

@export var _game_state_dir : GameStateDir

@export var _is_cell_selected : bool = false
@export var _selected_cell : Vector2i

signal move_triggered(move_dir: Def.MoveDir, start_pos: Vector2i)

# TODO: Move to separate tilemap that handles input independent of display tilemaps
func _input(event):
    if event is InputEventMouseButton:
        var pos = event.position
        var pos_local = to_local(pos)
        if event.pressed:
            # Mouse down
            var target_cell = local_to_map(pos_local)

            _is_cell_selected = true
            _selected_cell = target_cell
        else:
            # Mouse up
            pass

func _process(_delta):
    if not _is_cell_selected:
        return

    var move_dir = null

    # Collect input
    if Input.is_action_just_pressed("move_left"):
        move_dir = Def.MoveDir.MoveW;
    elif Input.is_action_just_pressed("move_up"):
        move_dir = Def.MoveDir.MoveN;
    elif Input.is_action_just_pressed("move_right"):
        move_dir = Def.MoveDir.MoveE;
    elif Input.is_action_just_pressed("move_down"):
        move_dir = Def.MoveDir.MoveS;

    if move_dir != null:
        # Update game state
        var new_pos : Vector2i = _game_state_dir.update_game_state(move_dir, _selected_cell)
        _selected_cell = new_pos

    # Update view
    clear();
    # todo get entire eel instead of just selected_cell
    set_cells_terrain_connect(0, [_selected_cell], 0, 0)
