extends Control

var ruta_nivel = "res://Scenes/Juego.tscn"

@onready var foto1 = $TextureRect2
@onready var foto2 = $TextureRect3

var tiempo_para_cambiar = 2.0
var temporizador = 0.0

func _ready():
	foto1.visible = true
	foto2.visible = false
	
	ResourceLoader.load_threaded_request(ruta_nivel)

func _process(delta):
	temporizador += delta
	
	if temporizador >= tiempo_para_cambiar:
		temporizador = 0.0
		
		foto1.visible = not foto1.visible
		foto2.visible = not foto2.visible
	
	var progreso = []
	var estado = ResourceLoader.load_threaded_get_status(ruta_nivel, progreso)
	
	if estado == ResourceLoader.THREAD_LOAD_LOADED:
		var escena_empaquetada = ResourceLoader.load_threaded_get(ruta_nivel)
		get_tree().change_scene_to_packed(escena_empaquetada)
