extends Area2D


var attraction = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func eat() -> void:
	attraction = 0
	$Grasspot.hide()
	$GrasspotGone.show()
