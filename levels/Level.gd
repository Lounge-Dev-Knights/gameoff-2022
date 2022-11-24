extends Node2D


var active_item: PackedScene

export(int) var bananas := 0
export(int) var apples := 0
export(int) var grasspots := 0


var current_room_position := position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_item_list()
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	for staircase in get_tree().get_nodes_in_group("staircases"):
		(staircase as Area2D).connect("body_entered", self, "_staircase_body_entered")
	active_item = load("res://environment/Mouse.tscn")

func _process(delta: float) -> void:
	update_current_room_position()
	position = position.linear_interpolate(current_room_position, 0.1)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var space_state = get_world_2d().direct_space_state
		if space_state.intersect_point(get_global_mouse_position()).size() == 0:
			handle_drop_item()

const ROOM_CHANGE_THRESHOLD = 100
func update_current_room_position() -> void:
	var nearest_room_position =  -($Elephant.position / get_viewport_rect().size).floor() * get_viewport_rect().size
	
	var offsetted_elephant_position = $Elephant.position - get_viewport_rect().size / 2
	
	if nearest_room_position.distance_to(offsetted_elephant_position) > current_room_position.distance_to(offsetted_elephant_position) + ROOM_CHANGE_THRESHOLD:
		current_room_position = nearest_room_position
	

func finish_level() -> void:
	get_tree().change_scene("res://Titlescreen.tscn")


func handle_drop_item() -> void:
	if active_item != null:
		var item = active_item.instance()
		item.position = get_local_mouse_position()
		$items.add_child(item)


func update_item_list() -> void:
	var item_list = $CanvasLayer/ItemList
	print(str(item_list.items))
	

func _staircase_body_entered(body: Node) -> void:
	finish_level()


func _on_ItemList_item_selected(index: int) -> void:
	# active_item = load("res://items/%s.tscn" % $CanvasLayer/ItemList.get_item_text(index))
	pass
	
	
