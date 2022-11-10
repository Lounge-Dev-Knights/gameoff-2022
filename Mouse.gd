extends Area2D

var attraction = -20

const MAX_SPEED = 500


var velocity: Vector2
var direction := Vector2.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity = velocity.linear_interpolate(direction * MAX_SPEED, delta * 20)
	position += velocity * delta


func _on_DirectionTimer_timeout() -> void:
	direction = direction.rotated(rand_range(0, 2 * PI))
