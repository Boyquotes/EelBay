@tool
class_name TestRunner extends Node2D

@export var run_tests := false: set = _set_run_tests

func _set_run_tests(value):
    if value:
        _run_tests()

func _run_tests():
    GameStateTest.find_eel_blocks__test()