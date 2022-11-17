extends StaticBody2D

var shaking_noise = OpenSimplexNoise.new()

enum State {
	NORMAL,
	SHAKING,
	BROKEN
}

var state = State.NORMAL


func _ready() -> void:
	randomize()
	shaking_noise.seed = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.SHAKING:
		var offset = OS.get_ticks_msec() * 0.2
		
		$Cupboard.offset = Vector2(
			shaking_noise.get_noise_1d(offset),
			shaking_noise.get_noise_1d(-offset)
		) * 64
		
		$Cupboard.rotation_degrees = 10.0 * shaking_noise.get_noise_1d(offset)


func hit() -> void:
	if state == State.NORMAL:
		state = State.SHAKING
		$Timer.start()
		SoundEngine.play_sound("Rocking")


func _on_Cupboard_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().set_input_as_handled()
		state = State.NORMAL
		$Timer.stop()


func _on_Timer_timeout() -> void:
	state = State.BROKEN
	modulate = Color.darkgray
	$CPUParticles2D.emitting = true
	SoundEngine.play_sound("Shatter")
