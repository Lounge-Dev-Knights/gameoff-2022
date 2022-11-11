extends Area2D

var attraction = -20

const MAX_SPEED = 500


var target: Node2D

var velocity: Vector2
var direction := Vector2.RIGHT


func _ready() -> void:
	var mouseholes = get_tree().get_nodes_in_group("mouseholes")
	mouseholes.shuffle()
	SoundEngine.play_sound("Mouse")
	
	for mousehole in mouseholes:
		if to_local(mousehole.global_position).length() > 1:
			target = mousehole
			return

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
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
