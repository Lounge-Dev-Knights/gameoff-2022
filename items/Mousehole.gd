extends Node2D

const SPAWN_CHANCE = 0.2

export var mouses = 0


func _ready() -> void:
	randomize()


func spawn_mouse() -> void:
	mouses -= 1
	var mouse = preload("res://items/Mouse.tscn").instance()
	mouse.set_as_toplevel(true)
	mouse.global_position = global_position
	add_child(mouse)


func _on_Spawntrigger_timeout() -> void:
	if mouses > 0 and randf() < SPAWN_CHANCE:
		spawn_mouse()
