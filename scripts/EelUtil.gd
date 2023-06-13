
const Def = preload("res://scripts/Def.gd")
const Eel = preload("res://scripts/Eel.gd")

# Takes a list of eels and returns a dictionary where key is pos and value is Eel
static func eel_array_to_dict(eels: Array[Eel]):
    var eels_dict = {}
    for eel in eels:
        eels_dict[eel.pos] = eel

    return eels_dict       