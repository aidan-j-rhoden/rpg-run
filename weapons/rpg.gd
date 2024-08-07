extends Node3D
const ROCKET = preload("res://weapons/rocket.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func fire() -> void:
	var rocket = ROCKET.instantiate()
	$launcher/rocket.hide()
	add_child(rocket)
	rocket.global_position = global_position
	rocket.global_rotation = global_rotation
	rocket.global_scale(Vector3(1, 1, 1))
	rocket.top_level = true
	rocket.fire()
