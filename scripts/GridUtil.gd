class_name GridUtil

const Def = preload("res://scripts/Def.gd")

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

static func neighboring_positions(pos : Vector2i) -> Array[Vector2i]:
    return [pos + Vector2i.RIGHT, pos + Vector2i.UP, pos + Vector2i.LEFT, pos + Vector2i.DOWN]

static func in_bounds(pos : Vector2i) -> bool:
    return pos.x >= 0 and pos.x < Def.BOARD_SIZE.x and pos.y >= 0 and pos.y < Def.BOARD_SIZE.y