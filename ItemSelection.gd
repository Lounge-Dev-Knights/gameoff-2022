extends CanvasLayer


signal item_selected(item)


func _on_Item_item_selected(item) -> void:
	emit_signal("item_selected", item)
