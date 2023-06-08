extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
class GameState:
	# Invariant: The pos value of the eels must match their position keys 
	var eels : Dictionary # Vector2i -> Eel
	
class Eel:
	var pos : Vector2i
	var color : EelColor

enum EelColor { EelRed, EelOrange, EelGreen }

enum MoveDir { MoveE, MoveN, MoveW, MoveS }

# Wrapper
class EelBlock:
	# Invariant: The array is non-empty
	var un_block : Array[Eel]
	
static func mk_singleton_eel_block(eel: Eel) -> EelBlock:
	var eel_block = EelBlock.new()
	eel_block.un_block = [eel]
	return eel_block
	
static func mk_eel_block(eels: Array[Eel]) -> EelBlock:
	var eel_block = EelBlock.new()
	eel_block.un_block = eels
	return eel_block

static func neighboring_positions(pos : Vector2i) -> Array[Vector2i]:
	return [pos + Vector2i.RIGHT, pos + Vector2i.UP, pos + Vector2i.LEFT, pos + Vector2i.DOWN]
		
# Invariant: The returned Array[Eel] is always non-empty.
# TODO: Incomplete, untested
static func find_eel_blocks(eels: Array[Eel]) -> Array[EelBlock]:
	var next_block_id = 0
	var block_map = {} # TODO: rename -- Map from positions to blockIDs
	var output_blocks = {} # accumulator -- Map from BlockID to EelBlock
	
	for eel in eels:
		# Search for adjacent blocks of the same color
		var adjacent_block_ids = {}
		for adjacent_pos in neighboring_positions(eel.pos):
			var maybe_block_id = block_map.find_key(adjacent_pos)
			# TODO: take into account eel colors
			if maybe_block_id != null:
				adjacent_block_ids[maybe_block_id] = null
				
		# Fuse with adjacent blocks, if any
		if adjacent_block_ids.is_empty():
			# Write block map
			block_map[eel.pos] = next_block_id
			# Insert singleton block
			output_blocks[next_block_id] = mk_singleton_eel_block(eel)
			next_block_id += 1
		else:
			var new_eels = []
			var new_block_id = adjacent_block_ids.keys().min() # non-empty
			# TODO: uniqueness of adjacent block IDs
			for block_id in adjacent_block_ids.keys():
				var eel_block = output_blocks[block_id]
				for eel_ in eel_block.un_block:
					# Collect all eels
					new_eels.push_back(eel_)
					# Rewrite block map
					block_map[eel_.pos] = new_block_id
				# Remove all old blocks
				output_blocks.delete(block_id)
			# Insert new block
			new_eels.push_back(eel)
			output_blocks[new_block_id] = mk_eel_block(new_eels)
			
	return output_blocks.values()
