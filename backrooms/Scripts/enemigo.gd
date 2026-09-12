extends CharacterBody3D
@export var speed: float = 0
@onready var player: CharacterBody3D = $"../Player2"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		print("player encontrado")
		nav_agent.target_position = player.global_position
		
		if global_position.distance_to(player.global_position) < 1.0:
			print("¡Posiciones coincidentes! El enemigo alcanzó al jugador.")

	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = next_path_pos - global_position
	print("¿Es alcanzable?: ", nav_agent.is_target_reachable())
	print("Dirección calculada: ", direction)
	direction.y = 0.0

	if direction.length_squared() <= 0.001:
		velocity.x = 0
		velocity.z = 0
	else:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	move_and_slide()
