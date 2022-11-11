extends Node2D


var active_item: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for staircase in get_tree().get_nodes_in_group("staircases"):
		(staircase as Area2D).connect("body_entered", self, "_staircase_body_entered")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var space_state = get_world_2d().direct_space_state
		if space_state.intersect_point(get_global_mouse_position()).size() == 0:
			handle_drop_item()


func _staircase_body_entered(body: Node) -> void:
	finish_level()


func finish_level() -> void:
	get_tree().change_scene("res://Titlescreen.tscn")


func handle_drop_item() -> void:
	if active_item != null:
		var item = active_item.instance()
		item.position = get_local_mouse_position()
		$items.add_child(item)


func _on_ItemList_item_selected(index: int) -> void:
	active_item = load("res://%s.tscn" % $CanvasLayer/ItemList.get_item_text(index))
	
	
