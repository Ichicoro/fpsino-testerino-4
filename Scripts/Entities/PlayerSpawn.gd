extends Node3D
class_name PlayerSpawn

@export var spawn_on_start: bool = true
@export var playerScene: PackedScene = preload("res://Player/Player.tscn")

func _ready() -> void:
	if spawn_on_start:
		var player = playerScene.instantiate()
		player.position = self.position
		player.rotation = self.rotation
		get_tree().root.get_node("Level").call_deferred("add_child", player)
	self.visible = false
