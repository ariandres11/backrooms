extends CharacterBody3D

@export var speed: float = 5.0
@onready var player: CharacterBody3D = $"../Player"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_caminar = $"Drunk Walking Turn/AnimationPlayer"
signal game_over
var jugador_atrapado: bool = false

func _ready() -> void:
	await get_tree().physics_frame
	
func _physics_process(delta: float) -> void:
	if jugador_atrapado:
		return

	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if player:
		nav_agent.target_position = player.global_position

	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = next_path_pos - global_position
	direction.y = 0.0

	if direction.length_squared() <= 0.001:
		velocity.x = 0
		velocity.z = 0
	else:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		anim_caminar.play("mixamo_com")
		anim_caminar.speed_scale = 1.5 
		
		var posicion_mirar = global_position + direction
		if global_position.distance_to(posicion_mirar) > 0.1:
			var transform_ideal = global_transform.looking_at(posicion_mirar, Vector3.UP)
			global_transform.basis = global_transform.basis.slerp(transform_ideal.basis, delta * 8.0).orthonormalized()

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.name == "Player":
			anim_caminar.play("atacar")
			print("El enemigo chocó con: ", collider.name)
			jugador_atrapado = true
			
			velocity = Vector3.ZERO
			
			
			await get_tree().create_timer(1.5).timeout
			
			game_over.emit()
