extends Node3D
@onready var animation_player: AnimationPlayer = $rocket/AnimationPlayer

@onready var explosion = preload("res://weapons/explosion.tscn")
@onready var HOLE = preload("res://weapons/hole.tscn")

@export var exploded: bool = false
var entered_body = null

var previous_position: Vector3

func fire() -> void:
	animation_player.play("boosterAction")


func explode(pos) -> void:
	exploded = true
	animation_player.pause()
	$rocket.hide()

	var efx = explosion.instantiate()
	add_child(efx)
	efx.global_position = pos
	efx.global_rotation.x = 0
	efx.global_rotation.z = 0
	efx.explode()
	await get_tree().create_timer(10).timeout
	queue_free()


func _physics_process(_delta: float) -> void:
		if not exploded:
			var space_state = get_world_3d().direct_space_state
			var from = previous_position
			var to = $rocket/booster/engine/Cylinder.global_transform.origin
			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.set_exclude([self])
			query.collide_with_bodies = true
			var result = space_state.intersect_ray(query)
			previous_position = $rocket/booster/engine/Cylinder.global_transform.origin

			if result and result.collider is not CharacterBody3D:
				print("raycast hit!")
				exploded = true
				var hole = HOLE.instantiate()
				print(result)
				result.collider.add_child(hole)
				hole.global_position = result.get("position") # $rocket/booster/engine/Cylinder.global_position
				var normal = result.get("normal")
				look_at(global_transform.origin + normal, Vector3.UP)
				if normal != Vector3.UP and normal != Vector3.DOWN:
					self.rotate_object_local(Vector3(1, 0, 0), 90)
				explode(result.position)
