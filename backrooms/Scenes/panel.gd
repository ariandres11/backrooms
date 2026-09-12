extends Panel

func _ready():
	visible = false # Nos aseguramos de que arranque oculto

func _on_enemigo_game_over():
	visible = true
	get_tree().paused = true # Congela todo el juego (excepto este panel)

func _process(delta: float) -> void:
	# Solo detectamos las teclas si estamos en la pantalla de Game Over
	if visible:
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
			
		# Suponiendo que uses la tecla de salto/aceptar para reiniciar
		if Input.is_action_just_pressed("jump"): 
			get_tree().paused = false # Quitamos la pausa antes de recargar
			get_tree().reload_current_scene() # Reinicia el nivel
