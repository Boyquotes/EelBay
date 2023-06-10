class_name GameStateDir

const Eel = preload("res://scripts/Eel.gd")

enum MoveDir { MoveE, MoveN, MoveW, MoveS }

class GameState:
    # Invariant: The pos value of the eels must match their position keys 
    var eels : Dictionary # Vector2i -> Eel
    
static func neighboring_positions(pos : Vector2i) -> Array[Vector2i]:
    return [pos + Vector2i.RIGHT, pos + Vector2i.UP, pos + Vector2i.LEFT, pos + Vector2i.DOWN]
        
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
            
    return output_blocks.values()