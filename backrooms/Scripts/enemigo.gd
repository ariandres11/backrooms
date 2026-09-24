extends CharacterBody3D

@export var speed: float = 5.0
@onready var player: CharacterBody3D = $"../Player"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
# Asegúrate de que esta ruta coincida con el nombre de tu modelo importado
@onready var anim = $"Drunk Walking Turn/AnimationPlayer"
signal game_over
var jugador_atrapado: bool = false

func _ready() -> void:
	await get_tree().physics_frame
	
func _physics_process(delta: float) -> void:
	# Si ya te atrapó, detenemos el cálculo de movimiento para que no siga empujando
	if jugador_atrapado:
		return

	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if player:
		nav_agent.target_position = player.global_position

	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = next_path_pos - global_position
	direction.y = 0.0

	# Cuando llega al objetivo o está quieto
	if direction.length_squared() <= 0.001:
		velocity.x = 0
		velocity.z = 0
		anim.pause() # Pausa la animación de caminar
	else:
		# Cuando está persiguiendo
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# 1. Reproducimos la animación y ajustamos la velocidad para que no patine
		anim.play("mixamo_com")
		anim.speed_scale = 1.5 
		
		# 2. Rotación suavizada y normalizada (Evita el error rojo en consola)
		var posicion_mirar = global_position + direction
		if global_position.distance_to(posicion_mirar) > 0.1:
			var transform_ideal = global_transform.looking_at(posicion_mirar, Vector3.UP)
			global_transform.basis = global_transform.basis.slerp(transform_ideal.basis, delta * 8.0).orthonormalized()

	move_and_slide()

	# Detección de colisión con el jugador
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.name == "Player":
			print("El enemigo chocó con: ", collider.name)
			jugador_atrapado = true
			
			# Frenamos en seco y pausamos la animación
			velocity = Vector3.ZERO
			anim.pause()
			
			# Esperamos 1.5 segundos antes de mostrar la pantalla de Game Over
			await get_tree().create_timer(1.5).timeout
			
			game_over.emit()
