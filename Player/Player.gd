extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 2.25

@onready var camera: Camera3D = $Camera3D
@onready var aim_raycast: RayCast3D = $Camera3D/RayCast3D

@onready var active_weapon: BaseWeapon = $Camera3D/SubViewportContainer/SubViewport/Camera3D/OnHand/Arm

@onready var OnHand = $Camera3D/SubViewportContainer/SubViewport/Camera3D/OnHand

var last_frame_input_data: PlayerInputData = PlayerInputData.new()
var input_data: PlayerInputData = PlayerInputData.new()

var mouse_movement: Vector2 = Vector2.ZERO

var last_ground_velocity: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	# var inpdata = input_data
	# input_data = PlayerInputData.new()
	# print(str(input_data.horizontal) + ";" + str(input_data.vertical))
	# Add the gravity.
	if not is_on_floor():
		motion_velocity.y -= gravity * delta
	else:
		last_ground_velocity = Vector2(motion_velocity.x, motion_velocity.z)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		motion_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if not is_on_floor():
			motion_velocity.x = direction.x * SPEED
			motion_velocity.z = direction.z * SPEED
		else:
			motion_velocity.x = direction.x * SPEED
			motion_velocity.z = direction.z * SPEED
	else:
		if is_on_floor():
			motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
			motion_velocity.z = move_toward(motion_velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		var vec = event.relative
		self.mouse_movement = Vector2(vec.y / 10, vec.x / 10)
