extends Node3D

var xNoise: OpenSimplexNoise
var yNoise: OpenSimplexNoise

var targetRot := Vector3.ZERO
var eventRot := Vector2.ZERO
var noiseRot := Vector3.ZERO
var noiseCount := 0
@export var noiseAmp := 10.0
@export var noiseFreq := 100.0

var mouseRot := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xNoise = OpenSimplexNoise.new()
	yNoise = OpenSimplexNoise.new()
	xNoise.seed = 0
	xNoise.octaves = 1
	yNoise.seed = 1
	yNoise.octaves = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseRot = event.relative
