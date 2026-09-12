extends CharacterBody3D
@export var speed: float = 0
@onready var player: CharacterBody3D = $"../Player"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
signal game_over
var jugador_atrapado: bool = false

func _ready() -> void:
	await get_tree().physics_frame
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if player:
		#print("player encontrado")
		nav_agent.target_position = player.global_position
		
		if global_position.distance_to(player.global_position) < 10:
			print("¡Posiciones coincidentes! El enemigo alcanzó al jugador.")

	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = next_path_pos - global_position
	#print("Dirección calculada: ", direction)
	direction.y = 0.0

	if direction.length_squared() <= 0.001:
		velocity.x = 0
		velocity.z = 0
	else:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.name == "Player":
			print("El enemigo chocó con: ", collider.name)
			jugador_atrapado = true
			game_over.emit()
