extends CanvasLayer


var floor_number := 0 setget _set_floor_number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_floor_number(new_floor: int) -> void:
	floor_number = new_floor
	$PanelContainer/MarginContainer/Label.text = str(floor_number)
