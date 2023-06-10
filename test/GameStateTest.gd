class_name GameStateTest

const Eel = preload("res://scripts/Eel.gd")
const Def = preload("res://scripts/Def.gd")

static func find_eel_blocks__test() -> bool:
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

    # Test Grid
    # R O O
    # O G
    var eels : Array[Eel] = [
        eel_red_00,
        eel_orange_01,
        eel_orange_02,
        eel_orange_10,
        eel_green_11
    ]

    print("IN EELS:")
    for eel in eels:
        print(eel)

    print("OUT BLOCKS:")
    var blocks = GameStateDir.find_eel_blocks(eels)
    for block in blocks:
        var out = ""
        for block_eel in block:
            out += str(block_eel) + " "
        print(out)

    # TODO: Instead of printing details, compare equality of the produced block set and 
    # the expected block set and return value as result of test
    var expected_blocks = {
        [eel_red_00]: null,
        [eel_orange_01, eel_orange_01]: null,
        [eel_orange_10]: null,
        [eel_green_11]: null
    }
    # TODO: Set[Array[Eel]] comparison util code
    return expected_blocks == expected_blocks