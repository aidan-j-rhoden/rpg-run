extends Node3D
@onready var animation_player: AnimationPlayer = $rocket/AnimationPlayer
@onready var explosion = preload("res://weapons/explosion.tscn")

func fire() -> void:
	#$rocket/booster/engine/Area3D.monitoring = true
	animation_player.play("boosterAction")


func explode() -> void:
	animation_player.pause()
	$rocket.hide()
	var efx = explosion.instantiate()
	add_child(efx)
	efx.global_position = $rocket/booster/engine/Cylinder.global_position
	efx.explode()
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	explode()
