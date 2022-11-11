extends StaticBody2D

var shaking_noise = OpenSimplexNoise.new()

var shaking := false

func _ready() -> void:
	randomize()
	shaking_noise.seed = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shaking:
		var offset = OS.get_ticks_msec() * 0.2
		
		$Cupboard.offset = Vector2(
			shaking_noise.get_noise_2d(offset, 0),
			shaking_noise.get_noise_2d(0, offset)
		) * 20

func hit() -> void:
	shaking = true


func _on_Cupboard_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().set_input_as_handled()
		shaking = false
