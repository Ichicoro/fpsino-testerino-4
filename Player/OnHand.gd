extends Node3D

var player: Player:
	get:
		return player
	set(p):
		player = p
		self._on_player_set(p)

var weapons: Array = [
	load("res://Player/Weapons/Arm.tscn").instantiate()
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_set(player: Player) -> void:
	for weapon in weapons:
		weapon.player = player


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_3:
			add_child(weapons[0])
		elif event.keycode == KEY_4:
			remove_child(weapons[0])
