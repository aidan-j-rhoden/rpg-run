extends Node3D
@onready var animation_player: AnimationPlayer = $rocket/AnimationPlayer

@onready var explosion = preload("res://weapons/explosion.tscn")
@onready var HOLE = preload("res://weapons/hole.tscn")
@onready var ray_cast_3d: RayCast3D = $rocket/booster/engine/Cylinder/RayCast3D

@export var exploded:bool = false

func fire() -> void:
	animation_player.play("boosterAction")


func explode() -> void:
	exploded = true
	animation_player.pause()
	$rocket.hide()

	var efx = explosion.instantiate()
	add_child(efx)
	efx.global_position = $rocket/booster/engine/Cylinder.global_position
	efx.global_rotation.x = 0
	efx.global_rotation.z = 0
	efx.explode()
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not exploded:
		print("area hit!")
		var space_state = get_world_3d().direct_space_state
		var from = $rocket/booster/engine/Cylinder.global_transform.origin
		var to = from + $rocket/booster/engine/Cylinder.global_position * 2
		var query = PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF, [self])
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)

		if result:
			print("raycast hit!")
			exploded = true
			var hole = HOLE.instantiate()
			body.add_child(hole)
			hole.global_position = result.get("position") # $rocket/booster/engine/Cylinder.global_position
			var normal = result.get("normal")
			look_at(global_transform.origin + normal, Vector3.UP)
			if normal != Vector3.UP and normal != Vector3.DOWN:
				self.rotate_object_local(Vector3(1, 0, 0), 90)
			explode()
