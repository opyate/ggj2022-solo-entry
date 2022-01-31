extends Node2D


func _on_Area2D_area_entered(_area):
	g.emit_signal("swap_key")
