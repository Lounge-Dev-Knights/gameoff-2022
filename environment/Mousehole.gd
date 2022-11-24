extends Node2D

const SPAWN_CHANCE = 0.2

export var mouses = 0


func _ready() -> void:
	randomize()


func spawn_mouse() -> void:
	mouses -= 1
	var mouse = preload("res://environment/Mouse.tscn").instance()
	mouse.position = position
	
	get_parent().add_child(mouse)


func _on_Spawntrigger_timeout() -> void:
	if mouses > 0 and randf() < SPAWN_CHANCE:
		spawn_mouse()
