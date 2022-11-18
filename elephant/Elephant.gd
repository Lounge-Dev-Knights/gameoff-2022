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
	MusicEngine.play_song("Music1")
	MusicEngine.secondary_player.volume_db = -80

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_process_state(delta)
	update()


func _physics_process(delta: float) -> void:
	move_and_slide(velocity)
	
	var collision = get_last_slide_collision()
	if state == State.FLEEING and collision != null and collision.collider.has_method("hit"):
		collision.collider.hit()


func _draw() -> void:
	if is_instance_valid(target):
		draw_circle(to_local(target.global_position), 5, Color.red)


# Fade duration for secondary music track
const FADE_DURATION = 0.3

func _process_state(delta: float) -> void:
	
	_process_music(delta)
	
	$Label.text = State.keys()[state]
	if velocity.x != 0.0:
		$LN_4elephant.scale.x = abs($LN_4elephant.scale.x) * sign(velocity.x)
	
	match state:
		State.IDLE:
			$LN_4elephant/AnimationPlayer.playback_speed = 1.0
			$LN_4elephant/AnimationPlayer.play("rest")
			
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
			$LN_4elephant/AnimationPlayer.playback_speed = 1.0
			$LN_4elephant/AnimationPlayer.play("walk")
			
			
			check_items()
			velocity = velocity.move_toward(to_local(target.global_position).clamped(MAX_SPEED), delta * 100)
			
			if to_local(target.global_position).length() <= sqrt(96 * 96 + 96 * 96):
				state = State.IDLE
				if target.is_in_group("items"):
					if target.has_method("eat"):
						target.eat()
					else:
						target.queue_free()
				SoundEngine.play_sound("El_Eat")
				target = null
		State.FLEEING:
			$LN_4elephant/AnimationPlayer.play("walk")
			$LN_4elephant/AnimationPlayer.playback_speed = 2.0
			
			
			# dont change velocity if target disappeared
			if is_instance_valid(target):
				velocity = -to_local(target.global_position).normalized() * MAX_SPEED * 2
			
			if randf() < 0.5 * delta:
				state = State.IDLE


func _process_music(delta: float) -> void:
	
	# currently the same pitch for both states
	var pitch =  1.0 if state == State.FLEEING else 1.0
	
	MusicEngine.secondary_player.pitch_scale = lerp(MusicEngine.secondary_player.pitch_scale, pitch, delta / 0.2)
	for player in MusicEngine.players:
		player.pitch_scale = lerp(player.pitch_scale, pitch, delta / 0.2)
	
	var secondary_volume = linear2db(0) if state == State.IDLE else -25 
	MusicEngine.secondary_player.volume_db = linear2db(lerp(db2linear(MusicEngine.secondary_player.volume_db), db2linear(secondary_volume), delta / FADE_DURATION))
	


func check_items() -> void:
	var bodies = $ItemDetectionArea.get_overlapping_areas()
	bodies.sort_custom(self, 'compare_items')
	for body in bodies:
		if body.attraction == 0:
			continue
			
		# skip items which are beneath walls
		$RayCast2D.cast_to = to_local(body.global_position)
		$RayCast2D.force_raycast_update()
		if $RayCast2D.get_collider():
			continue
			
		target = body
		state = State.WALKING if body.attraction >= 0 else State.FLEEING 
		
		if body.attraction <= 0:
			SoundEngine.play_sound("El_Scream")


func compare_items(a, b) -> int:
	var value_a = abs(a.attraction) * 500 - to_local(a.global_position).length()
	var value_b = abs(b.attraction) * 500 - to_local(b.global_position).length()
	
	return value_b > value_a
