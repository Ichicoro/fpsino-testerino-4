extends Object
class_name NormalMovement

var player: Player
var last_ground_velocity: Vector2 = Vector2.ZERO

func _init(player: Player) -> void:
	super()
	self.player = player

func update(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _move() -> void:
	var jumping = false
	
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	else:
		last_ground_velocity = Vector2(velocity.x, velocity.z)

	# Handle Jump
	if Input.is_action_pressed("jump") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = player_dir.normalized()
	if is_on_floor() and not jumping:
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, delta * ACCELERATION) # direction.x * SPEED
			velocity.z = move_toward(velocity.z, direction.z * SPEED, delta * ACCELERATION) # direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, delta * ACCELERATION)
			velocity.z = move_toward(velocity.z, 0, delta * ACCELERATION)
	else:
		_air_accelerate(direction, player_dir.length(), AIR_ACCELERATE, delta)
