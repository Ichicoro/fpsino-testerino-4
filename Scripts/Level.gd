extends Node3D
class_name Level

@export var respawn_point: Vector3
@export var kill_y: float = -20

var killY_area3d: Area3D

func _ready() -> void:
	self._setup_killplane()


func _setup_killplane() -> void:
	killY_area3d = Area3D.new()
	killY_area3d.position.y = kill_y
	var cs3d = CollisionShape3D.new()
	cs3d.shape = BoxShape3D.new()
	cs3d.shape.size = Vector3(100000000, 1, 100000000)
	killY_area3d.add_child(cs3d)
	killY_area3d.connect("body_entered", self._on_killzone_body_entered)
	self.add_child(killY_area3d)


func _on_killzone_body_entered(body: Node3D):
	print(body)
	body.position = respawn_point
	body.rotation = Vector3.ZERO
	if body is RigidDynamicBody3D:
		body.set_axis_velocity(Vector3.ZERO)	# TODO: hmm...?
	if body is Player:
		body.camera.rotation = Vector3.ZERO
