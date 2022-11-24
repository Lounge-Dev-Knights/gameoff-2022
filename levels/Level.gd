extends Node2D


const ROOM_CHANGE_THRESHOLD = 100
const CAMERA_SNAP = Vector2(1920, 1080) / 2


var active_item: PackedScene

export(int) var bananas := 0
export(int) var apples := 0
export(int) var grasspots := 0


var camera_target_position := Vector2()

var camera := Camera2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.current = true
	camera.position = $Elephant.position
	add_child(camera)
	
	if $ItemSelection != null:
		$ItemSelection.connect("item_selected", self, "_on_ItemSelection_item_selected")
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	for staircase in get_tree().get_nodes_in_group("staircases"):
		(staircase as Area2D).connect("body_entered", self, "_staircase_body_entered")

func _process(delta: float) -> void:
	update_current_camera_position()
	camera.position = camera.position.linear_interpolate(camera_target_position, 0.05)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var space_state = get_world_2d().direct_space_state
		if space_state.intersect_point(get_global_mouse_position()).size() == 0:
			handle_drop_item()


func update_current_camera_position() -> void:
	var nearest_camera_position = $Elephant.position.snapped(CAMERA_SNAP)
	
	if nearest_camera_position.distance_to($Elephant.position) < camera_target_position.distance_to($Elephant.position) + ROOM_CHANGE_THRESHOLD:
		camera_target_position = nearest_camera_position
	

func finish_level() -> void:
	get_tree().change_scene("res://Titlescreen.tscn")


func handle_drop_item() -> void:
	if active_item != null:
		var item = active_item.instance()
		item.position = get_local_mouse_position()
		$items.add_child(item)


func _staircase_body_entered(body: Node) -> void:
	finish_level()


func _on_ItemSelection_item_selected(item: PackedScene) -> void:
	active_item = item
