extends VBoxContainer

signal item_selected(item)


export(int) var cost := 100
export(Texture) var texture
export(PackedScene) var item


var initial_cost = cost

func _ready() -> void:
	$TextureButton.texture_normal = texture
	$Price.text = "%d$" % cost

func _on_TextureButton_pressed() -> void:
	emit_signal("item_selected", item)


func on_dropped(dropped_item) -> void:
	if item == dropped_item:
		get_tree().call_group("cost_counter", "add_cost", -cost)
		cost += initial_cost
		$Price.text = "%d$" % cost
