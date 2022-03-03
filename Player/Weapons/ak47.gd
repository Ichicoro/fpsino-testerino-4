extends BaseWeapon
class_name AK47

var   last_fired   := 0
const MAG_SIZE     := 30
const FIRE_RATE    := 0.10
var   in_cartridge := 30
var   remaining    := 90
var   is_reloading := false

@onready var anim_player = $AnimationPlayer
@onready var ray = $RayCast3D
@onready var audio_player = $AudioStreamPlayer
@onready var model = $BasePosition/model

const decal = preload("res://Player/Weapons/AkShotDecal.tscn")

func _init():
	self.weaponSlot = WeaponSlot.ONE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_time = Time.get_ticks_msec()
	if not $AnimationPlayer.is_playing():
		self.bob_weapon(model, delta)
	
	if Input.is_action_pressed("fire") and current_time > (last_fired + FIRE_RATE*1000):
		if in_cartridge > 0 and not is_reloading:
			shoot()
	
	if Input.is_action_just_pressed("reload") and not is_reloading:
		is_reloading = true
		$AnimationPlayer.play("reload")
		await get_tree().create_timer(1.25).timeout
		var remainder = MAG_SIZE - in_cartridge
		in_cartridge += remainder
		remaining -= remainder
		is_reloading = false

func shoot():
	last_fired = Time.get_ticks_msec()
	audio_player.play()
	$AnimationPlayer.seek(0)
	$AnimationPlayer.play("shoot")
	
	if ray.is_colliding():
		var normal = ray.get_collision_normal() as Vector3
		var point = ray.get_collision_point() as Vector3
		var object = ray.get_collider() as Node3D
		
		var decalInstance = decal.instantiate()
		decalInstance.position = point
		align_up(decalInstance.transform, normal)
		
		object.add_child(decalInstance)
	
	in_cartridge -= 1

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
#		var motion = event.relative as Vector2
#		self.bob_weapon(model, motion)


func align_up(node_basis, normal):
	var result = Basis()
	var scale = node_basis.basis.get_scale() # Only if your node might have a scale other than (1,1,1)

	result.x = normal.cross(node_basis.basis.z)
	result.y = normal
	result.z = node_basis.basis.x.cross(normal)

	result = result.orthonormalized()
	node_basis.basis = result
