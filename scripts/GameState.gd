class_name GameState

# Invariant: The pos value of the eels must match their position keys 
var eels : Dictionary # Vector2i -> Eel

func _init(_eels : Dictionary):
    eels = _eels

func copy() -> GameState:
    return GameState.new(eels.duplicate(true))