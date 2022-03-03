extends BaseWeapon

var last_slap = 0
var slap_count = 0

func _init() -> void:
	self.weaponSlot = WeaponSlot.THREE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent) -> void:
	var current_time = Time.get_ticks_msec()
	if Input.is_action_just_pressed("fire") and not $AnimationPlayer.is_playing():
		last_slap = Time.get_ticks_msec()
		$AnimationPlayer.play('slap', -1, 1.5)


func slapp():
	if player.aim_raycast.is_colliding():
		$AudioStreamPlayer.play(0.15)
		var coll: Node3D = player.aim_raycast.get_collider()
		if coll is RigidDynamicBody3D and coll.name == "karen":
			player.get_node("HUD/PointsSpawner").spawn_points_label("+50 points!", Vector2(15, 50))
			var slap_direction = player.get_global_transform().basis.z*-100
			slap_direction.y = 100
			coll.apply_force(slap_direction, player.aim_raycast.get_collision_point())
			player.get_node("HUD/PointsSpawner").spawn_points_label("slapp %d" % slap_count, Vector2(15, 50))
			slap_count += 1

func on_switch_out():
	$AnimationPlayer.stop()
	$AnimationPlayer.seek(0)

func on_switch_in():
	pass
