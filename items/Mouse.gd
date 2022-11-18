extends Area2D

var attraction = -20

const MAX_SPEED = 500


var target: Node2D

var picked := false
var pickable := true

var velocity: Vector2
var direction := Vector2.RIGHT


func _ready() -> void:
	var mouseholes = get_tree().get_nodes_in_group("mouseholes")
	mouseholes.shuffle()
	SoundEngine.play_sound("Mouse")
	
	for mousehole in mouseholes:
		if to_local(mousehole.global_position).length() > 1:
			target = mousehole

func sort_by_distance(a, b) -> bool:
	return to_local(a.global_position) < to_local(b.global_position)

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if picked:
		position += get_local_mouse_position()
	else:
		$Mouse.flip_h = velocity.x < 0
		if to_local(target.global_position).length() < 10:
			target.mouses += 1
			queue_free()


func _physics_process(delta: float) -> void:
	if target != null:
		velocity = to_local(target.global_position).normalized() * MAX_SPEED
	else:
		velocity = velocity.linear_interpolate(direction * MAX_SPEED, delta * 20)
	
	position += velocity * delta


func _on_DirectionTimer_timeout() -> void:
	direction = direction.rotated(rand_range(0, 2 * PI))


func _on_Mouse_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if pickable and event is InputEventMouseButton:
		$PickedTimer.start()
		picked = event.is_pressed()


func _on_PickedTimer_timeout() -> void:
	picked = false
	pickable = false
	
	var mouseholes = get_tree().get_nodes_in_group("mouseholes")
	mouseholes.sort_custom(self, "sort_by_distance")
	
	if len(mouseholes) > 0:
		target = mouseholes[0]
