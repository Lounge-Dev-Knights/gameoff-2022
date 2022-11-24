extends StaticBody2D

enum Value {
	HIGH,
	MEDIUM,
	LOW
}

export(bool) var destructible := true
export(Value) var value := Value.MEDIUM

var shaking_noise = OpenSimplexNoise.new()

enum State {
	NORMAL,
	SHAKING,
	BROKEN
}


var state = State.NORMAL

var origin: Vector2


func _ready() -> void:
	randomize()
	
	origin = position
	shaking_noise.seed = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.SHAKING:
		var offset = OS.get_ticks_msec() * 0.2
		
		
		
		position = origin + Vector2(
			shaking_noise.get_noise_1d(offset),
			shaking_noise.get_noise_1d(-offset)
		) * 8
		look_at(global_position + Vector2.RIGHT.rotated(0.05 * shaking_noise.get_noise_1d(offset)))
		
		


func hit() -> void:
	if state == State.NORMAL:
		state = State.SHAKING
		$Timer.start()
		SoundEngine.play_sound("Rocking")


func _on_Cupboard_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().set_input_as_handled()
		state = State.SHAKING
		$Timer.stop()


func _on_Timer_timeout() -> void:
	state = State.BROKEN
	modulate = Color.darkgray
	if $Dustcloud != null:
		$Dustcloud.emitting = true
	SoundEngine.play_sound("Shatter")
