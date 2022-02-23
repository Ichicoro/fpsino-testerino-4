extends BaseWeapon
class_name AK47

var   last_fired   := 0
const MAG_SIZE     := 30
const FIRE_RATE    := 60/600
var   in_cartridge := 30
var   remaining    := 90

@onready var anim_player = $AnimationPlayer
@onready var ray = $RayCast3D
@onready var audio_player = $AudioStreamPlayer

func _init():
	self.weaponSlot = WeaponSlot.ONE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_time = Time.get_ticks_msec()
	print("trying to fire at %d" % current_time)
	if Input.is_action_pressed("fire") and last_fired + FIRE_RATE*1000 < current_time:
		last_fired = Time.get_ticks_msec()
		print("fired at %d" % current_time)
		audio_player.play()


func _input(event: InputEvent) -> void:
	pass
#		anim_player.play('slap', -1, 1.5)
