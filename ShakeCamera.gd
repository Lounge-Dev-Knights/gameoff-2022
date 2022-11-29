extends Camera2D
class_name ShakeCamera

export var max_offset : float = 50.0
export var max_roll : float = 10.0
export var trauma_reduction : float = 2

var base_seed: int = 0
export(float, 0.0, 1.0) var trauma : float = 0.0


var peek_offset = Vector2()
var peek_active = false

func _ready():
	randomize()
	add_to_group("shake_cameras")
	base_seed = randi()
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if peek_active:
			peek_offset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2) / 14
		else:
			peek_offset = Vector2()
# TODO: Add in some sort of rotation reset.
func _process(_delta):  
	_process_shake(global_transform.origin, 0.0, _delta)
	
	offset = offset.linear_interpolate(peek_offset, 0.1)
	
	
	
func _process_shake(center, angle, delta) -> void:
	if trauma > 0:
		var shake = pow(trauma, 2) * 1.0
		var rotation_offset = angle + (max_roll * shake *  _get_noise(base_seed, OS.get_ticks_msec()))
		
		
		var offset_x = (max_offset * shake * _get_noise(base_seed + 1, OS.get_ticks_msec()))
		var offset_y = (max_offset * shake * _get_noise(base_seed + 2, OS.get_ticks_msec()))
		
		transform = Transform2D(rotation_offset / 360.0, Vector2(offset_x, offset_y))
		
		trauma -= trauma_reduction * delta
		
		trauma = clamp(trauma, 0.0, 1.0)
	else:
		transform = Transform2D()
	
	
func _get_noise(noise_seed, time) -> float:
	var n = OpenSimplexNoise.new()
	
	n.seed = noise_seed
	n.octaves = 2
	n.period = 20.0
	n.persistence = 0.8
	
	return n.get_noise_1d(time)
	
	
func add_trauma(amount: float) -> void:
	trauma += amount
	trauma = clamp(trauma, 0.0, 1.0)
