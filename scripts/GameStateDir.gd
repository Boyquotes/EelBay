class_name GameStateDir
extends Node

const Def = preload("res://scripts/Def.gd")
const Eel = preload("res://scripts/Eel.gd")
const GameState = preload("res://scripts/GameState.gd")

signal game_state_changed(game_state : GameState)

var global_game_state : GameState;

func _ready():
    global_game_state = GameStateDir.create_init_game_state()
    game_state_changed.emit(global_game_state)
    
static func create_init_game_state():
    var eel_red_00 = Eel.new(
        Vector2i(0,0),
        Def.EelColor.EelRed 
    )

    var eel_orange_01 = Eel.new(
        Vector2i(0,1),
        Def.EelColor.EelOrange
    )

    var eel_orange_02 = Eel.new(
        Vector2i(0,2),
        Def.EelColor.EelOrange
    )

    var eel_orange_10 = Eel.new(
        Vector2i(1,0),
        Def.EelColor.EelOrange
    )

    var eel_green_11 = Eel.new(
        Vector2i(1,1),
        Def.EelColor.EelGreen
    )

    var eels : Array[Eel] = [
        eel_red_00,
        eel_orange_01,
        eel_orange_02,
        eel_orange_10,
        eel_green_11
    ]

    var eels_dict = eel_array_to_dict(eels)
    
    return GameState.new(eels_dict)

# Takes a list of eels and returns a dictionary where key is pos and value is Eel
static func eel_array_to_dict(eels: Array[Eel]):
    var eels_dict = {}
    for eel in eels:
        eels_dict[eel.pos] = eel

    return eels_dict       

static func neighboring_positions(pos : Vector2i) -> Array[Vector2i]:
    return [pos + Vector2i.RIGHT, pos + Vector2i.UP, pos + Vector2i.LEFT, pos + Vector2i.DOWN]

static func move_dir_to_vec(move_dir : Def.MoveDir) -> Vector2i:
    match move_dir:
        Def.MoveDir.MoveE:
            return Vector2i.RIGHT
        Def.MoveDir.MoveN:
            return Vector2i.UP
        Def.MoveDir.MoveW:
            return Vector2i.LEFT
        Def.MoveDir.MoveS:
            return Vector2i.DOWN
        
    return Vector2i.ZERO

# Placeholder functionality for testing game state tick - just moves an single eel without checking collision
static func tick_game_state(move_dir: Def.MoveDir, start_pos: Vector2i, game_state : GameState) -> GameState:
    var new_pos : Vector2i = start_pos + move_dir_to_vec(move_dir)

    if game_state.eels.has(new_pos) or not game_state.eels.has(start_pos):
        return game_state

    var new_game_state : GameState = game_state.copy()

    new_game_state.eels[new_pos] = new_game_state.eels[start_pos] 
    new_game_state.eels.erase(start_pos)

    return new_game_state

# Invariant: The returned Array[Eel] is always non-empty.
# TODO: Incomplete, untested
# Returns: Array[Array[Eel]] An array of eel blocks
static func find_eel_blocks(eels: Array[Eel]):
    var next_block_id = 0
    var block_map = {} # TODO: rename -- Map from positions to blockIDs
    var output_blocks = {} # accumulator -- Map from BlockID to Array[Eel]
    
    for eel in eels:
        # Search for adjacent blocks of the same color
        var adjacent_block_ids = {}
        for adjacent_pos in neighboring_positions(eel.pos):
            var maybe_block_id = block_map.get(adjacent_pos)
            #print(maybe_block_id)
            if maybe_block_id != null:
                var maybe_block = output_blocks.get(maybe_block_id)
                if maybe_block[0].color == eel.color:
                    # Add adjacent block of the same color to set
                    adjacent_block_ids[maybe_block_id] = null
                
        # Fuse with adjacent blocks, if any
        if adjacent_block_ids.is_empty():
            # Write block map
            block_map[eel.pos] = next_block_id
            # Insert singleton block
            output_blocks[next_block_id] = [eel]
            next_block_id += 1
        else:
            var new_eels : Array[Eel] = []
            var new_block_id = adjacent_block_ids.keys().min() # non-empty
            # TODO: uniqueness of adjacent block IDs
            for block_id in adjacent_block_ids.keys():
                var eel_block = output_blocks[block_id]
                for eel_ in eel_block:
                    # Collect all eels
                    new_eels.push_back(eel_)
                    # Rewrite block map
                    block_map[eel_.pos] = new_block_id
                # Remove all old blocks
                output_blocks.erase(block_id)
            # Insert new block
            new_eels.push_back(eel)
            output_blocks[new_block_id] = new_eels

    # create dictionary for output
    var output_blocks_set = {}
    for block in output_blocks.values():
        output_blocks_set[block] = null

    return output_blocks_set


func _on_move_triggered(move_dir, start_pos):
    global_game_state = GameStateDir.tick_game_state(move_dir, start_pos, global_game_state)
    game_state_changed.emit(global_game_state)
