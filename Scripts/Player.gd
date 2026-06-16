extends CharacterBody3D

#Movement and Stamina
var speed
var WALK_SPEED = 4.0
var SPRINT_SPEED = 6
var max_stamina = 100.0
var current_stamina = 100.0
var stamina_drain_rate = 20.0
var stamina_regen_rate = 20.0
var exhausted = false
#Mouse Sens
const SENSITIVITY = 0.003

#Items and Inventory
var current_item = "nothing"


#Head Bob
var BOB_FREQ = 2.4
var BOB_MAX = 1
var BOB_AMP = 0.2
var t_bob = 0.0
var has_interacted_once:bool = false

#FOV 
var BASE_FOV = 75.0
var FOV_CHANGE = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var burger_model: MeshInstance3D = $Head/Camera3D/Hand/BurgerModel
@onready var reciept_model: MeshInstance3D = $Head/Camera3D/Hand/RecieptModel




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Sprint and Stamina
	if Input.is_action_pressed("sprint") and not exhausted:
		speed = SPRINT_SPEED
		current_stamina -= stamina_drain_rate * delta
		
		
	else:
		speed = WALK_SPEED
		current_stamina += stamina_regen_rate * delta
		
	#Exhaustion and Head Bob + FOV Effects
	current_stamina = clamp(current_stamina, 0.0, max_stamina)
	if current_stamina <= 0.0:
		BOB_AMP = 0.5
		BOB_FREQ = 2.5
		BASE_FOV = 50.0
		exhausted = true
	if current_stamina >= max_stamina:
		BOB_AMP = 0.2
		BOB_FREQ = 2.4
		BASE_FOV = 75.0
		
		exhausted = false

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			if not has_interacted_once:
				BOB_AMP = BOB_AMP + 0.001
			if BOB_AMP >= BOB_MAX:
				BOB_AMP = BOB_MAX 
			
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func lock_headbob():
	has_interacted_once = true
	BOB_AMP = 0.1
	
func hold_item(name_of_item):
	current_item = name_of_item
	print("Player is now holding: ", current_item)
	
	# Safety first: Hide both models so they don't overlap!
	burger_model.visible = false
	reciept_model.visible = false
	
	# Now, check the exact string name to see what to show
	if current_item == "Borgir":
		burger_model.visible = true
	elif current_item == "Reciept":
		reciept_model.visible = true
	
