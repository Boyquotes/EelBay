class_name BoardInputDir
extends TileMap

const Def = preload("res://scripts/Def.gd")
const InputData = preload("res://scripts/InputData.gd")

signal move_triggered(move_dir: Def.MoveDir, start_pos: Vector2i)

var _is_cell_selected : bool = false
var _selected_cell : Vector2i
var _input_data : InputData = null;

var _got_input_this_frame : bool = false;

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

        _got_input_this_frame = true

# PROCESS PRIORITY = 0
func _process(_delta):
    if _got_input_this_frame:
        _input_data = null;

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
            _input_data = InputData.new(move_dir, _selected_cell)

        # TODO: optimize this to only draw when the input happens
        draw()

func get_input() -> InputData:
    return _input_data

func recieve_update_data(update_data : GameStateDir.GameStateUpdateData):
    if update_data._eel_update_data != null:
        _selected_cell = update_data._eel_update_data._new_eel_pos

        # we need to redraw because the selection changed based on the game state
        draw()

func draw():
    clear();
    # todo draw entire eel block instead of just selected_cell
    set_cells_terrain_connect(0, [_selected_cell], 0, 0)
