extends CanvasLayer

signal item_selected(item)


func _on_ItemList_item_selected(index: int) -> void:
	var item = load("res://items/%s.tscn" % $ItemList.get_item_text(index))
	emit_signal("item_selected", item)
