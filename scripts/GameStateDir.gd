class_name GameStateDir
extends Node

const BoardInputDir = preload("res://scripts/BoardInputDir.gd")
const Def = preload("res://scripts/Def.gd")
const Eel = preload("res://scripts/Eel.gd")
const GameState = preload("res://scripts/GameState.gd")
const InputData = preload("res://scripts/InputData.gd")
const GridUtil = preload("res://scripts/GridUtil.gd")

class EelUpdateData:
    var _new_eel_pos : Vector2i

    func _init(new_eel_pos : Vector2i):
        _new_eel_pos = new_eel_pos

class GameStateUpdateData:
    var _new_game_state : GameState
    var _eel_update_data : EelUpdateData

    func _init(new_game_state : GameState, eel_update_data : EelUpdateData):
        _new_game_state = new_game_state
        _eel_update_data = eel_update_data

signal game_state_changed(game_state : GameState)

@export var _input_dir : BoardInputDir
var _global_game_state : GameState = null

func set_game_state(value : GameState):
    _global_game_state = value 
    game_state_changed.emit(_global_game_state)

func _ready():
    var new_game_state : GameState = GameStateDir.create_init_game_state()
    set_game_state(new_game_state)

# PROCESS PRIORITY = 1
func _process(delta):
    var input_data = _input_dir.get_input()
    var update_data = update_game_state(input_data)
    _input_dir.recieve_update_data(update_data)

# Updates game state and returns the new position of eel
func update_game_state(input_data : InputData) -> GameStateUpdateData:
    var update_data : GameStateUpdateData = GameStateDir.tick_game_state(input_data, _global_game_state)
    set_game_state(update_data._new_game_state)
    return update_data
    
static func create_init_game_state():
    var rng = RandomNumberGenerator.new()
    var count = 10
    var eels = {}
    for i in range(count):
        var pos = Vector2i(rng.randi_range(0, Def.BOARD_SIZE.x-1), rng.randi_range(0, Def.BOARD_SIZE.y-1))
        eels[pos] = Eel.new(pos, rng.randi_range(0, Def.EelColor.size()-1))

    return GameState.new(eels)

# Placeholder functionality for testing game state tick - just moves an single eel without checking collision
static func tick_game_state(input_data : InputData, game_state : GameState) -> GameStateUpdateData:
    # Use this value if you need tick in logic below
    var tick = game_state._tick
    game_state._tick += 1

    if input_data == null:
        return GameStateUpdateData.new(game_state, null)

    var start_pos = input_data._start_pos
    var move_dir = input_data._move_dir

    var new_pos : Vector2i = start_pos + GridUtil.move_dir_to_vec(move_dir)

    if game_state.eels.has(new_pos) or not game_state.eels.has(start_pos) or not GridUtil.in_bounds(new_pos):
        return GameStateUpdateData.new(game_state, EelUpdateData.new(start_pos))

    var new_game_state : GameState = game_state.copy()

    new_game_state.eels[new_pos] = new_game_state.eels[start_pos] 
    new_game_state.eels.erase(start_pos)

    return GameStateUpdateData.new(new_game_state, EelUpdateData.new(new_pos))

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
        for adjacent_pos in GridUtil.neighboring_positions(eel._pos):
            var maybe_block_id = block_map.get(adjacent_pos)
            #print(maybe_block_id)
            if maybe_block_id != null:
                var maybe_block = output_blocks.get(maybe_block_id)
                if maybe_block[0].color == eel._color:
                    # Add adjacent block of the same color to set
                    adjacent_block_ids[maybe_block_id] = null
                
        # Fuse with adjacent blocks, if any
        if adjacent_block_ids.is_empty():
            # Write block map
            block_map[eel._pos] = next_block_id
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
                    block_map[eel_._pos] = new_block_id
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
