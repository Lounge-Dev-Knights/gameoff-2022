extends CanvasLayer

signal floor_reached


var floor_number := 0 setget _set_floor_number


func _set_floor_number(new_floor: int) -> void:
	while floor_number != new_floor:
		yield(get_tree().create_timer(0.2), "timeout")
		floor_number += sign(new_floor - floor_number)
		$PanelContainer/MarginContainer/Label.text = str(floor_number)
	
	emit_signal("floor_reached")
