extends Node3D
@onready var animation_player: AnimationPlayer = $rocket/AnimationPlayer

func fire() -> void:
	#$rocket/booster/engine/Area3D.monitoring = true
	animation_player.play("boosterAction")


func explode() -> void:
	animation_player.pause()
	$rocket/booster/engine/GPUParticles3D.emitting = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	explode()
