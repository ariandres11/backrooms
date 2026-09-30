extends CharacterBody3D

const BASE_SPEED = 80.0
const RUN_SPEED = BASE_SPEED + BASE_SPEED * 0.5
const JUMP_VELOCITY = 4.5
const BOB_FREQ = 2.4 # frecuencia de pasos
const BOB_AMP = 0.08 # amplitud de rebote
var t_bob = 0.0

@onready var camera_pivot = $camera_pivot
@onready var camera = $camera_pivot/Camera3D 

var mouse_sensitivity = 0.002

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -deg_to_rad(80),deg_to_rad(80))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var current_speed = BASE_SPEED
	if Input.is_action_pressed("run"):
		current_speed = RUN_SPEED

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

	var velocidad_normalizada = velocity.length() / BASE_SPEED
	
	t_bob += delta * velocidad_normalizada * 5.0 * float(is_on_floor())
	
	var pos_y = sin(t_bob * BOB_FREQ) * BOB_AMP
	var pos_x = cos(t_bob * BOB_FREQ / 2.0) * BOB_AMP
	
	if is_on_floor() and velocity.length() > 0.1:
		camera.position.y = lerpf(camera.position.y, pos_y, delta * 10.0)
		camera.position.x = lerpf(camera.position.x, pos_x, delta * 10.0)
	else:
		camera.position.y = lerpf(camera.position.y, 0.0, delta * 10.0)
		camera.position.x = lerpf(camera.position.x, 0.0, delta * 10.0)
