extends "res://util/PersistentProperties.gd"

var total_cost: int = 0


func _init():
	# override filename
	filepath = 'user://scores.json'
