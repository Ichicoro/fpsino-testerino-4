extends Area3D
class_name Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_interaction_text(player: Player) -> String:
	return "Press [key]interact[/key] to [b]eat pp[/b]"