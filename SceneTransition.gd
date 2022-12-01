extends CanvasLayer


var floor_number := 0 setget _set_floor_number


func _set_floor_number(new_floor: int) -> void:
	floor_number = new_floor
	$PanelContainer/MarginContainer/Label.text = str(floor_number)
