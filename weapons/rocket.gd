extends Node3D
@onready var animation_player: AnimationPlayer = $rocket/AnimationPlayer

func _ready() -> void:
	$rocket/booster/engine/Cylinder/Area3D.monitoring = false

func fire() -> void:
	animation_player.play("boosterLaunch")


func explode() -> void:
	animation_player.pause()
	#queue_free()


func _on_area_3d_area_entered(_area: Area3D) -> void:
	explode()
