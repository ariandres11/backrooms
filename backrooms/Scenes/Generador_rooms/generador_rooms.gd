extends Node3D
@export var tiles: Array[PackedScene]

func _ready() -> void:
	if tiles.is_empty():
		print("No hay rooms cargadas en el generador")
		return
		
	var tile_sorteado = tiles.pick_random()
	
	if tile_sorteado != null:
		var nueva_habitacion :Node3D= tile_sorteado.instantiate()
		add_child(nueva_habitacion)
		nueva_habitacion.position = Vector3.ZERO
		print("habitacion instanciada al azar")
