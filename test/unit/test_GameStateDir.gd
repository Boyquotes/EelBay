extends GutTest

const Eel = preload("res://scripts/Eel.gd")
const Def = preload("res://scripts/Def.gd")

class Test_GameStateDir_find_eel_blocks:
    extends GutTest

    var eel_red_00
    var eel_orange_01
    var eel_orange_02
    var eel_orange_10
    var eel_green_11

    func before_each():
        eel_red_00 = Eel.new(
            Vector2i(0,0),
            Def.EelColor.EelRed 
        )

        eel_orange_01 = Eel.new(
            Vector2i(0,1),
            Def.EelColor.EelOrange
        )

        eel_orange_02 = Eel.new(
            Vector2i(0,2),
            Def.EelColor.EelOrange
        )

        eel_orange_10 = Eel.new(
            Vector2i(1,0),
            Def.EelColor.EelOrange
        )

        eel_green_11 = Eel.new(
            Vector2i(1,1),
            Def.EelColor.EelGreen
        )

    func test_find_eel_blocks():
        var eels : Array[Eel] = [
            eel_red_00,
            eel_orange_01,
            eel_orange_02,
            eel_orange_10,
            eel_green_11
        ]

        var blocks = GameStateDir.find_eel_blocks(eels)

        var expected_blocks = {
            [eel_red_00]: null,
            [eel_orange_01, eel_orange_02]: null,
            [eel_orange_10]: null,
            [eel_green_11]: null
        }

        assert_eq_deep(blocks, expected_blocks)