extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 2.25

const MAX_AIR_WISH_SPEED = 20
const AIR_ACCELERATE = 100		# Hu/39.97

@onready var camera: Camera3D = $Camera3D
@onready var aim_raycast: RayCast3D = $Camera3D/RayCast3D

@onready var active_weapon: BaseWeapon = $Camera3D/OnHand/Arm

@onready var OnHand = $Camera3D/OnHand

# DEBUG NODES
@onready var debug_speed_label = $HUD/Speed_Label

var last_frame_input_data: PlayerInputData = PlayerInputData.new()
var input_data: PlayerInputData = PlayerInputData.new()

var mouse_movement: Vector2 = Vector2.ZERO

var last_ground_velocity: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# ===== UTILS =====
func _get_2d_velocity() -> Vector2:
	return Vector2(motion_velocity.x, motion_velocity.z)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for item in OnHand.get_children():
		if item is BaseWeapon:
			item.player = self

func _process(delta):
	last_frame_input_data = input_data
	input_data = PlayerInputData.new()
	self.rotate_y(self.mouse_movement.y * -1 * delta * MOUSE_SENSITIVITY)
	var x_rotation = self.mouse_movement.x * -1 * delta * MOUSE_SENSITIVITY
	camera.rotation.x = clamp(camera.rotation.x + x_rotation, deg2rad(-90), deg2rad(90))
	self.mouse_movement = Vector2.ZERO

func _physics_process(delta):
	var jumping = false
	# var inpdata = input_data
	# input_data = PlayerInputData.new()
	# print(str(input_data.horizontal) + ";" + str(input_data.vertical))
	# Add the gravity.
	if not is_on_floor():
		motion_velocity.y -= gravity * delta
	else:
		last_ground_velocity = Vector2(motion_velocity.x, motion_velocity.z)

	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		motion_velocity.y = JUMP_VELOCITY
		jumping = true

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var based = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var direction = based.normalized()
	if is_on_floor() and not jumping:
		if direction:
			motion_velocity.x = direction.x * SPEED
			motion_velocity.z = direction.z * SPEED
		else:
			motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
			motion_velocity.z = move_toward(motion_velocity.z, 0, SPEED)
	else:
		_air_accelerate(direction, based.length(), AIR_ACCELERATE, delta)

	debug_speed_label.text = "%0.3f" % _get_2d_velocity().length()
	move_and_slide()


func _air_accelerate(wish_dir: Vector3, wish_speed: float, airaccelerate: float, delta_time: float):
	var addspeed: float = 0
	var accelspeed: float = 0
	var currentspeed: float = 0
#	var wish_dir_3d = Vector3(wish_dir.x, 0, wish_dir.y)
	
	if wish_speed > MAX_AIR_WISH_SPEED:
		wish_speed = MAX_AIR_WISH_SPEED
	
	currentspeed = motion_velocity.dot(wish_dir)
	
	addspeed = wish_speed - currentspeed
	if addspeed <= 0:
		return
	
	accelspeed = airaccelerate * delta_time * wish_speed
	
	if accelspeed > addspeed:
		accelspeed = addspeed
	
	motion_velocity += accelspeed * wish_dir


func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		var vec = event.relative
		self.mouse_movement = Vector2(vec.y / 10, vec.x / 10)
