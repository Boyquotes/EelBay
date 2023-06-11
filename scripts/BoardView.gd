extends Node2D

const Def = preload("res://scripts/Def.gd")

@export var green_tile_map : TileMap
@export var red_tile_map : TileMap
@export var orange_tile_map : TileMap

const GREEN_TILEMAP_TERRAIN = 0
const ORANGE_TILEMAP_TERRAIN = 1
const RED_TILEMAP_TERRAIN = 2

func _ready():
    clear()

func _on_game_state_dir_game_state_changed(game_state : GameState):
    clear()
    
    # TODO: Filter eel dictionary by color and set each tilemap accordingly.
    var green_eel_coord = filter_eels_by_color(Def.EelColor.EelGreen, game_state.eels).keys()
    var orange_eel_coord = filter_eels_by_color(Def.EelColor.EelOrange, game_state.eels).keys()
    var red_eel_coord = filter_eels_by_color(Def.EelColor.EelRed, game_state.eels).keys()

    green_tile_map.set_cells_terrain_connect(0, green_eel_coord, 0, GREEN_TILEMAP_TERRAIN)
    orange_tile_map.set_cells_terrain_connect(0, orange_eel_coord, 0, ORANGE_TILEMAP_TERRAIN)
    red_tile_map.set_cells_terrain_connect(0, red_eel_coord, 0, RED_TILEMAP_TERRAIN)

func clear():
    green_tile_map.clear()
    orange_tile_map.clear()
    red_tile_map.clear()

func filter_eels_by_color(color : Def.EelColor, eels : Dictionary):
    var color_eels = {}

    for pos in eels:
        if eels[pos].color == color:
            color_eels[pos] = eels[pos]

    return color_eels
