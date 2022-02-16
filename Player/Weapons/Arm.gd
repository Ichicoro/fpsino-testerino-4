extends BaseWeapon

var last_slap = 0
var slap_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent) -> void:
	var current_time = Time.get_ticks_msec()
#	print("last_slap: %d, current_time: %d, diff: %d" % [last_slap, current_time, current_time-last_slap])
	if Input.is_action_just_pressed("fire") and not $AnimationPlayer.is_playing(): #last_slap+1000 < current_time:
		last_slap = Time.get_ticks_msec()
		slapp()
		player.get_node("HUD/PointsSpawner").spawn_points_label("slapp %d" % slap_count, Vector2(15, 50))
		slap_count += 1


func slapp():
	$AnimationPlayer.play('slap')
	await get_tree().create_timer(0.4).timeout
	if player.aim_raycast.is_colliding():
		$AudioStreamPlayer.play(0.15)
		var coll: Node3D = player.aim_raycast.get_collider()
		if coll is RigidDynamicBody3D and coll.name == "karen":
			player.get_node("HUD/PointsSpawner").spawn_points_label("+50 points!", Vector2(15, 50))
			var slap_direction = player.get_global_transform().basis.z*-100
			slap_direction.y = 100
			coll.apply_force(slap_direction, player.aim_raycast.get_collision_point())
