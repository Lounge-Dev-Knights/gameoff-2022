extends CanvasLayer


var cost := 0

func add_cost(value: int) -> void:
	cost += value
	$PanelContainer/MarginContainer/HBoxContainer/Cost.text = "%d$" % cost
