extends Node


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Juego.tscn")
	


func _on_boton_salir_pressed() -> void:
	get_tree().quit()
