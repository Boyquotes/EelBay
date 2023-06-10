class_name GameStateTest

static func find_eel_blocks__test() -> bool:
    var eel_red_00 = GameStateDirector.mk_eel(
        Vector2i(0,0),
        GameStateDirector.EelColor.EelRed 
    )

    var eel_orange_01 = GameStateDirector.mk_eel(
        Vector2i(0,1),
        GameStateDirector.EelColor.EelOrange
    )

    var eel_orange_02 = GameStateDirector.mk_eel(
        Vector2i(0,2),
        GameStateDirector.EelColor.EelOrange
    )

    var eel_orange_10 = GameStateDirector.mk_eel(
        Vector2i(1,0),
        GameStateDirector.EelColor.EelOrange
    )

    var eel_green_11 = GameStateDirector.mk_eel(
        Vector2i(1,1),
        GameStateDirector.EelColor.EelGreen
    )

    # Test Grid
    # R O O
    # O G
    var eels : Array[GameStateDirector.Eel] = [
        eel_red_00,
        eel_orange_01,
        eel_orange_02,
        eel_orange_10,
        eel_green_11
    ]

    print("IN EELS:")
    for eel in eels:
        print(GameStateDirector.eel_to_string(eel))

    print("OUT BLOCKS:")
    var blocks = GameStateDirector.find_eel_blocks(eels)
    for block in blocks:
        var out = ""
        for block_eel in block:
            out += GameStateDirector.eel_to_string(block_eel) + " "
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