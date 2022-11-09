extends Node2D


var active_item: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		handle_drop_item()
		
		
func handle_drop_item() -> void:
	if active_item != null:
		var item = active_item.instance()
		item.position = get_local_mouse_position()
		$items.add_child(item)

func _on_ItemList_item_selected(index: int) -> void:
	match $CanvasLayer/ItemList.get_item_text(index):
		'Apple':
			active_item = preload("res://Apple.tscn")
	
