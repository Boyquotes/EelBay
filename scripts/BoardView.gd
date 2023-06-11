extends TileMap

func _ready():
    clear()

func _on_game_state_dir_game_state_changed(game_state : GameState):
    clear()
    var eel_coord = game_state.eels.keys()
    set_cells_terrain_connect(0, eel_coord, 0, 0)
