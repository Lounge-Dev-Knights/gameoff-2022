extends Node2D


const ROOM_CHANGE_THRESHOLD = 100
const CAMERA_SNAP = Vector2(1920, 1080) / 4


var active_item: PackedScene

export(int) var bananas := 0
export(int) var apples := 0
export(int) var grasspots := 0

var following_levels := []

var camera_target_position := Vector2()

var camera := Position2D.new()
var camera_instance := ShakeCamera.new()
var cost_counter

func _ready() -> void:
	camera_instance.current = true
	camera_instance.rotating = true
	camera.position = $Elephant.position
	camera_target_position = $Elephant.position
	camera.add_child(camera_instance)
	add_child(camera)
	
	cost_counter = preload("res://CostCounter.tscn").instance()
	add_child(cost_counter)
	add_child(preload("res://ToTitlescreenButton.tscn").instance())
	
	if $ItemSelection != null:
		$ItemSelection.connect("item_selected", self, "_on_ItemSelection_item_selected")
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	for staircase in get_tree().get_nodes_in_group("staircases"):
		(staircase as Area2D).connect("body_entered", self, "_staircase_body_entered")


func _process(delta: float) -> void:
	update_current_camera_position()
	camera.position = camera.position.linear_interpolate(camera_target_position, delta * 5)


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
	Scores.total_cost += cost_counter.cost
	if len(following_levels) > 0:
		var next_level = following_levels.pop_front()
		SceneLoader.goto_scene(next_level, {"following_levels": following_levels})
	else:
		SceneLoader.goto_scene("res://Titlescreen.tscn")


func handle_drop_item() -> void:
	if active_item != null:
		var item = active_item.instance()
		
		get_tree().call_group("item_selectors", "on_dropped", active_item)
		item.position = get_local_mouse_position()
		$items.add_child(item)
		active_item = null


func _staircase_body_entered(body: Node) -> void:
	finish_level()


func _on_ItemSelection_item_selected(item: PackedScene) -> void:
	active_item = item
