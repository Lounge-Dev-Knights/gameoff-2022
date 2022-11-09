extends KinematicBody2D

const MAX_SPEED = 200

enum State {
	IDLE,
	WALKING,
	FETCHING,
	FLEEING
}

var state: int

var target: Node2D

var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$FreeTarget.set_as_toplevel(true)
	pass # Replace with function body.
	MusicEngine.play_song("Music1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_process_state(delta)
	update()


func _physics_process(delta: float) -> void:
	move_and_slide(velocity)


func _draw() -> void:
	if target:
		draw_circle(to_local(target.global_position), 5, Color.red)
	

func _process_state(delta: float) -> void:
	$Label.text = State.keys()[state]
	
	match state:
		State.IDLE:
			$LN_4elephant/AnimationPlayer.play("rest")
			MusicEngine.secondary_player.volume_db =linear2db(0)
			velocity *= (0.9 * delta)
			check_items()
			if randf() < 0.3 * delta:
				state = State.WALKING
				$RayCast2D.cast_to = to_local(Vector2(rand_range(0, 640), rand_range(0, 300)))
				$RayCast2D.force_raycast_update()
				if $RayCast2D.get_collider():
					$FreeTarget.global_position = $RayCast2D.get_collision_point()
				else:
					$FreeTarget.global_position = to_global($RayCast2D.cast_to)
					
				target = $FreeTarget
				
				
				# target = Vector2(rand_range(0, 640), rand_range(0, 300))
		State.WALKING:
			$LN_4elephant/AnimationPlayer.play("walk")
			MusicEngine.secondary_player.volume_db=-25
			check_items()
			velocity = velocity.move_toward(to_local(target.global_position).clamped(MAX_SPEED), delta * 100)
			
			if to_local(target.global_position).length() <= sqrt(32 * 32 + 32 * 32):
				state = State.IDLE
				if target.is_in_group("items"):
					target.queue_free()
				target = null


func check_items() -> void:
	var bodies = $ItemDetectionArea.get_overlapping_areas()
	bodies.sort_custom(self, 'compare_items')
	for body in bodies:
		target = body
		state = State.WALKING


func compare_items(a, b) -> int:
	var value_a = a.attraction * 500 - to_local(a.global_position).length()
	var value_b = b.attraction * 500 - to_local(b.global_position).length()
	
	return value_b > value_a
