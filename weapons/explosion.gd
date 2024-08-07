extends Node3D

func explode() -> void:
	for child in $Particles.get_children():
		child.emitting = true
