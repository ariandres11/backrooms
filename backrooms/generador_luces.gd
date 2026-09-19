@tool
extends Node3D

@export var filas: int = 10
@export var columnas: int = 10
@export var separacion_metros: float = 4.0
@export var generar_luces_ahora: bool = false:
	set(value):
		generar_luces_ahora = false # Lo vuelve a apagar como si fuera un botón
		if Engine.is_editor_hint():
			_crear_cuadricula()
			
@export var limpiar_luces_ahora: bool = false:
	set(value):
		limpiar_luces_ahora = false # Lo vuelve a apagar al hacer clic
		if Engine.is_editor_hint():
			_limpiar_luces()

func _crear_cuadricula():
	var luz_base = $Luz
	
	for x in filas:
		for z in columnas:
			if x == 0 and z == 0:
				continue
			
			var nueva_luz = luz_base.duplicate()
			add_child(nueva_luz)
			
			nueva_luz.position = luz_base.position + Vector3(x * separacion_metros, 0, z * separacion_metros)
			
			nueva_luz.owner = get_tree().edited_scene_root
			
func _limpiar_luces():
	for hijo in get_children():
		if hijo.name != "Luz":
			hijo.free()
			
			
